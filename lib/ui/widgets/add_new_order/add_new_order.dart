import 'package:flutter/material.dart';

class AddNewOrder extends StatelessWidget {
  const AddNewOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add New Order', style: TextStyle(fontSize: 18)),
          // Add form fields here
          ElevatedButton(
            onPressed: () {
              // Add order logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}