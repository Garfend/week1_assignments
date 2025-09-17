import 'package:assignment1/data/models/order_model.dart';
import 'package:assignment1/data/repository/top_selling_reports_repository.dart';

class TopSellingReportsRepositoryImp implements TopSellingReportsRepository{
  final List<OrderModel> orders;

  TopSellingReportsRepositoryImp(this.orders);

  @override
  Map<String, int> topSellingItems() {
    final counts = <String, int>{};
    for (var order in orders) {
      counts[order.itemDrink.drinkName] =
          (counts[order.itemDrink.drinkName] ?? 0) + order.quantity;
    }
    return counts;
  }
}