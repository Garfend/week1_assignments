import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/models/constants/order_status.dart';
import '../../domain/usecase/order_usecase.dart';
import 'confirmation_dialog.dart';
import 'custom_widgets/custom_button.dart';
import 'update_status_button/update_status_button.dart';
import 'update_status_button/available_status.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onUpdateStatus;
  final OrderUsecase? orderService;
  final VoidCallback? onOrderDeleted;

  const OrderCard({
    super.key,
    required this.order,
    this.onUpdateStatus,
    this.orderService,
    this.onOrderDeleted,
  });

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

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.complete:
        return Colors.green;
    }
  }

  Future<void> _cancelOrder(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Cancel Order',
      content: 'Are you sure you want to cancel order #${order.orderNumber}?',
      confirmText: 'Yes, Cancel',
      cancelText: 'No',
      confirmTextColor: Colors.red,
    );

    if (confirmed == true && orderService != null) {
      try {
        await orderService!.deleteOrder(order.orderId);
        onOrderDeleted?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Order #${order.orderNumber} cancelled successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to cancel order')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCancel =
        order.orderStatus != OrderStatus.complete && orderService != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(order.orderStatus),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    order.orderStatus.name.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order.orderStatus),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildInfoRow('Customer', order.customerName),
                const SizedBox(height: 8),
                _buildInfoRow('Item', order.items.itemName),
                if (order.specialInstructions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow('Instructions', order.specialInstructions),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${order.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: UpdateStatusButton(
                    statusUI: _getStatusUI(order.orderStatus),
                    onPressed: onUpdateStatus,
                  ),
                ),
                if (canCancel) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: () => _cancelOrder(context),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
