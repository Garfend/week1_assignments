import '../../models/order_model.dart';
import '../../models/constants/order_status.dart';
import '../daily_reports_repository.dart';

class DailyReportsRepositoryImp implements DailyReportsRepository {
  final List<OrderModel> orders;

  DailyReportsRepositoryImp(this.orders);

  List<OrderModel> get _todayCompletedOrders {
    final today = DateTime.now();
    return orders.where((order) =>
    order.orderDate.year == today.year &&
        order.orderDate.month == today.month &&
        order.orderDate.day == today.day &&
        order.orderStatus == OrderStatus.complete
    ).toList();
  }

  @override
  double totalSales() => _todayCompletedOrders.fold<double>(0.0, (sum, order) => sum + order.total);

  @override
  int totalItemsSold() => _todayCompletedOrders.fold<int>(0, (sum, order) => sum + order.quantity);
}