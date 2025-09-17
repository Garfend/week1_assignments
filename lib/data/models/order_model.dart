import 'constants/order_status.dart';
import 'item_drink.dart';

class OrderModel {
  final String orderId;

  final ItemDrink itemDrink;

  final String customerName;

  final String specialInstructions;

  final OrderStatus orderStatus;

  final int quantity;

  final double total;



  OrderModel({
    required this.orderId,
    required this.itemDrink,
    required this.customerName,
    required this.specialInstructions,
    required this.orderStatus,
    required this.quantity,
    required this.total
  });

}
