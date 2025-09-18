import '../../models/constants/order_status.dart';
import '../../models/order_model.dart';
import '../base_reports_repository.dart';

class OverallReportsRepository extends BaseReportsRepository {
  OverallReportsRepository(super.orders);

  @override
  List<OrderModel> getFilteredOrders() {
    return orders.where((order) => order.orderStatus == OrderStatus.complete).toList();
  }
}