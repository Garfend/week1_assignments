import '../../models/order_model.dart';
import '../../models/constants/order_status.dart';
import '../daily_reports_repository.dart';

class DailyReportsRepositoryImp implements DailyReportsRepository {
  final List<OrderModel> orders;
  final DateTime? selectedDate;

  DailyReportsRepositoryImp(this.orders, {this.selectedDate});

  List<OrderModel> get _todayCompletedOrders {
    final targetDate = selectedDate ?? DateTime.now();
    return orders.where((order) =>
    order.orderDate.year == targetDate.year &&
        order.orderDate.month == targetDate.month &&
        order.orderDate.day == targetDate.day &&
        order.orderStatus == OrderStatus.complete
    ).toList();
  }

  @override
  double totalSales() => _todayCompletedOrders.fold<double>(0.0, (sum, order) => sum + order.total);

  @override
  int totalItemsSold() => _todayCompletedOrders.fold<int>(0, (sum, order) => sum + order.quantity);

  // Additional helper methods
  bool get hasDataForSelectedDate => _todayCompletedOrders.isNotEmpty;

  String get dateDisplayText {
    final target = selectedDate ?? DateTime.now();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(target.year, target.month, target.day);

    if (selected == today) {
      return 'Today';
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${target.day}/${target.month}/${target.year}';
    }
  }
}