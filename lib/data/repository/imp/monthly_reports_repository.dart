import '../../models/constants/order_status.dart';
import '../../models/order_model.dart';
import '../base_reports_repository.dart';

class MonthlyReportsRepository extends BaseReportsRepository {
  final int? month;
  final int? year;

  MonthlyReportsRepository(super.orders, {this.month, this.year});

  @override
  List<OrderModel> getFilteredOrders() {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    return orders.where((order) =>
    order.orderDate.month == targetMonth &&
        order.orderDate.year == targetYear &&
        order.orderStatus == OrderStatus.complete
    ).toList();
  }
}