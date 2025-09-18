import 'package:flutter/material.dart';
import '../../../data/models/item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/constants/order_status.dart';
import '../../../data/local/app_datasource.dart';
import '../../../domain/usecase/order_usecase.dart';
import '../item_picker.dart';

class AddNewOrderBottomSheet extends StatefulWidget {
  final VoidCallback? onOrderAdded;
  final OrderUsecase? orderService;

  const AddNewOrderBottomSheet({
    super.key,
    this.onOrderAdded,
    this.orderService,
  });

  @override
  State<AddNewOrderBottomSheet> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddNewOrderBottomSheet> {
  final _customerController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  List<ItemModel> _drinks = [];
  ItemModel? _selectedDrink;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDrinks();
  }

  Future<void> _loadDrinks() async {
    final drinks = await AppDatasource().getAllItems();
    setState(() {
      _drinks = drinks;
      if (drinks.isNotEmpty) _selectedDrink = drinks.first;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _customerController.dispose();
    _instructionsController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addOrder() async {
    if (_selectedDrink == null ||
        _customerController.text.trim().isEmpty ||
        int.tryParse(_quantityController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }
    final quantity = int.parse(_quantityController.text);
    final order = OrderModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: 1, // This will be overwritten by the database
      items: _selectedDrink!,
      customerName: _customerController.text.trim(),
      specialInstructions: _instructionsController.text.trim(),
      orderStatus: OrderStatus.pending,
      quantity: quantity,
      total: _selectedDrink!.itemPrice * quantity,
      orderDate: DateTime.now(),
    );
    if (widget.orderService != null) {
      await widget.orderService!.addOrder(order);
    } else {
      await AppDatasource().insertOrder(order);
    }
    widget.onOrderAdded?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Order', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ItemPicker(
              item: _drinks,
              selectedDrink: _selectedDrink,
              onChanged: (drink) => setState(() => _selectedDrink = drink),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customerController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(labelText: 'Special Instructions'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addOrder,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}