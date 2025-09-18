import 'constants/order_status.dart';
import 'item_model.dart';

class OrderModel {
  final String orderId;

  final int orderNumber;

  final ItemModel items;

  final String customerName;

  final String specialInstructions;

  final OrderStatus orderStatus;

  final int quantity;

  final double total;

  final DateTime orderDate;



  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.items,
    required this.customerName,
    required this.specialInstructions,
    required this.orderStatus,
    required this.quantity,
    required this.total,
    required this.orderDate
  });

}
