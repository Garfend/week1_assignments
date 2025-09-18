import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';

class ItemPicker extends StatelessWidget {
  final List<ItemModel> item;
  final ItemModel? selectedDrink;
  final ValueChanged<ItemModel> onChanged;

  const ItemPicker({
    super.key,
    required this.item,
    required this.selectedDrink,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ItemModel>(
      value: selectedDrink,
      hint: const Text('Select Drink'),
      isExpanded: true,
      items: item.map((drink) {
        return DropdownMenuItem<ItemModel>(
          value: drink,
          child: Text('${drink.itemName} (\$${drink.itemPrice})'),
        );
      }).toList(),
      onChanged: (drink) {
        if (drink != null) onChanged(drink);
      },
    );
  }
}