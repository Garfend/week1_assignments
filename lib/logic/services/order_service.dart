import '../../data/models/order_model.dart';
import '../../data/models/constants/order_status.dart';
import '../../data/repository/order_repository.dart';

class OrderService {
  final OrderRepository repository;

  OrderService(this.repository);

  Future<List<OrderModel>> getAllOrders() => repository.getAllOrders();

  Future<void> addOrder(OrderModel order) => repository.addOrder(order);

  Future<void> updateOrderStatus(String orderId, OrderStatus status) =>
      repository.updateOrderStatus(orderId, status);

  Future<List<OrderModel>> filterByStatus(OrderStatus status) =>
      repository.filterByStatus(status);
}