import 'package:flutter/material.dart';
import '../../data/models/item_drink.dart';

class DrinkPicker extends StatelessWidget {
  final List<ItemDrink> drinks;
  final ItemDrink? selectedDrink;
  final ValueChanged<ItemDrink> onChanged;

  const DrinkPicker({
    super.key,
    required this.drinks,
    required this.selectedDrink,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ItemDrink>(
      value: selectedDrink,
      hint: const Text('Select Drink'),
      isExpanded: true,
      items: drinks.map((drink) {
        return DropdownMenuItem<ItemDrink>(
          value: drink,
          child: Text('${drink.drinkName} (\$${drink.drinkPrice})'),
        );
      }).toList(),
      onChanged: (drink) {
        if (drink != null) onChanged(drink);
      },
    );
  }
}