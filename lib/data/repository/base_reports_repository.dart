import '../models/order_model.dart';

abstract class BaseReportsRepository {
  final List<OrderModel> orders;

  BaseReportsRepository(this.orders);

  // Template method - defines the algorithm structure
  List<OrderModel> getFilteredOrders();

  // Common calculations using the filtered orders
  double totalSales() => getFilteredOrders().fold<double>(0.0, (sum, order) => sum + order.total);

  int totalItemsSold() => getFilteredOrders().fold<int>(0, (sum, order) => sum + order.quantity);

  bool get hasOrders => getFilteredOrders().isNotEmpty;

  int get totalOrders => getFilteredOrders().length;

  double get averageOrderValue {
    final filtered = getFilteredOrders();
    return filtered.isEmpty ? 0.0 : totalSales() / filtered.length;
  }
}