import 'package:flutter/material.dart';
import '../../../data/models/item_model.dart';
import '../../../domain/usecase/item_usecase.dart';
import '../custom_widgets/custom_input_text_field.dart';
import '../custom_widgets/custom_button.dart';

class AddNewItemBottomSheet extends StatefulWidget {
  final ItemUsecase itemService;
  final VoidCallback? onItemAdded;

  const AddNewItemBottomSheet({
    super.key,
    required this.itemService,
    this.onItemAdded,
  });

  @override
  State<AddNewItemBottomSheet> createState() => _AddNewItemBottomSheetState();
}

class _AddNewItemBottomSheetState extends State<AddNewItemBottomSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text);
    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid name and price')),
      );
      return;
    }
    final item = ItemModel(
      itemId: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: name,
      itemPrice: price,
    );
    await widget.itemService.addItem(item);
    widget.onItemAdded?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add New Item', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          CustomInputTextField(
            controller: _nameController,
            label: 'Item Name',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 12),
          CustomInputTextField(
            controller: _priceController,
            label: 'Item Price',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Add',
            onPressed: _addItem,
          ),
        ],
      ),
    );
  }
}