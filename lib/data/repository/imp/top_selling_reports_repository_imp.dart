import 'package:assignment1/data/models/order_model.dart';
import 'package:assignment1/data/models/constants/order_status.dart';
import 'package:assignment1/data/repository/top_selling_reports_repository.dart';

class TopSellingReportsRepositoryImp implements TopSellingReportsRepository {
  final List<OrderModel> orders;

  TopSellingReportsRepositoryImp(this.orders);

  @override
  Map<String, int> topSellingItems() {
    final counts = <String, int>{};
    final completedOrders = orders.where((order) => order.orderStatus == OrderStatus.complete);

    for (var order in completedOrders) {
      counts[order.items.itemName] =
          (counts[order.items.itemName] ?? 0) + order.quantity;
    }
    return counts;
  }
}