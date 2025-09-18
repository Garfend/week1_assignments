import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import '../../domain/usecase/item_usecase.dart';
import '../widgets/item_card.dart';
import '../widgets/add_new_item/add_new_item_bottomsheet.dart';

class ItemsPage extends StatefulWidget {
  final ItemUsecase itemService;
  const ItemsPage({super.key, required this.itemService});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: FutureBuilder<List<ItemModel>>(
        future: widget.itemService.getAllItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No items yet.'));
          }
          return ListView(
            children: items.map((item) => ItemCard(
              item: item,
              itemService: widget.itemService,
              onItemDeleted: _refresh,
            )).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddNewItemBottomSheet(
              itemService: widget.itemService,
              onItemAdded: _refresh,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Item'),
      ),
    );
  }
}