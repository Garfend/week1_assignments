import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/models/constants/order_status.dart';
import 'update_status_button/update_status_button.dart';
import 'update_status_button/available_status.dart';

class DrinkCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onUpdateStatus;

  const DrinkCard({super.key, required this.order, this.onUpdateStatus});

  OrderStatusUI _getStatusUI(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return PendingStatusUI();
      case OrderStatus.inProgress:
        return InProgressStatusUI();
      case OrderStatus.complete:
        return CompleteStatusUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(order.itemDrink.drinkName),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${order.customerName}'),
                if (order.specialInstructions.isNotEmpty)
                  Text('Instructions: ${order.specialInstructions}'),
                Text('Quantity: ${order.quantity}'),
                Text('Total: ${order.total.toStringAsFixed(2)}'),
                Text('Status: ${order.orderStatus.name}'),
              ],
            ),
            UpdateStatusButton(
              statusUI: _getStatusUI(order.orderStatus),
              onPressed: onUpdateStatus,
            ),
          ],
        ),
      ),
    );
  }
}
