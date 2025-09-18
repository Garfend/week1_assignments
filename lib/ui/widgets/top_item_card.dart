import 'package:flutter/material.dart';

class TopItemCard extends StatelessWidget {
  final String itemName;
  final int soldCount;
  final int index;

  const TopItemCard({
    super.key,
    required this.itemName,
    required this.soldCount,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.local_cafe, color: Colors.blue),
        ),
        title: Text(
          itemName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Sold: $soldCount', style: const TextStyle(fontSize: 14)),
        trailing: Text(index.toString()),
      ),
    );
  }
}