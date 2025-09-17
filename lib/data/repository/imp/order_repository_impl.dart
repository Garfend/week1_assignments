import '../../models/constants/order_status.dart';
import '../../models/order_model.dart';
import '../../local/app_database.dart';
import '../order_repository.dart';

class OrderRepositorySQLite implements OrderRepository {
  final AppDatabase _db = AppDatabase();

  @override
  Future<List<OrderModel>> getAllOrders() => _db.getAllOrders();

  @override
  Future<void> addOrder(OrderModel order) => _db.insertOrder(order);

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) =>
      _db.updateOrderStatus(orderId, status);

  @override
  Future<List<OrderModel>> filterByStatus(OrderStatus status) async {
    final all = await getAllOrders();
    return all.where((o) => o.orderStatus == status).toList();
  }
}