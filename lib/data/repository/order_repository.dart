import '../models/constants/order_status.dart';
import '../models/order_model.dart';

abstract class OrderRepository{
  Future<List<OrderModel> >getAllOrders();
  Future<void> addOrder(OrderModel order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<List<OrderModel>> filterByStatus(OrderStatus status);
}