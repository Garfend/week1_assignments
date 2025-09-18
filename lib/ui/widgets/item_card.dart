import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import '../../domain/usecase/item_usecase.dart';
import 'confirmation_dialog.dart';
import 'custom_widgets/custom_button.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final ItemUsecase? itemService;
  final VoidCallback? onItemDeleted;

  const ItemCard({
    super.key,
    required this.item,
    this.itemService,
    this.onItemDeleted,
  });

  Future<void> _deleteItem(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Item',
      content: 'Are you sure you want to delete "${item.itemName}"?',
      confirmText: 'Delete',
      confirmTextColor: Colors.red,
    );

    if (confirmed == true && itemService != null) {
      try {
        await itemService!.deleteItem(item.itemId);
        onItemDeleted?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.itemName} deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete item')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.local_cafe),
        title: Text(item.itemName),
        subtitle: Text('\$${item.itemPrice.toStringAsFixed(2)}'),
        trailing: itemService != null
            ? SizedBox(
          width: 100,
          child: CustomButton(
            text: 'Delete',
            onPressed: () => _deleteItem(context),
          ),
        )
            : null,
      ),
    );
  }
}