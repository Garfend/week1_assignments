import 'package:assignment1/data/models/order_model.dart';
import 'package:assignment1/data/repository/daily_reports_repository.dart';

class DailyReportsRepositoryImp implements DailyReportsRepository {
  final List<OrderModel> orders;

  DailyReportsRepositoryImp(this.orders);

  @override
  double totalSales() => orders.fold(0, (sum, order) => sum + order.itemDrink.drinkPrice);

  @override
  int totalItemsSold() => orders.fold(0, (sum, order) => sum + order.quantity);
}
