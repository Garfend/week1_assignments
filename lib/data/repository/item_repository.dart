import 'package:assignment1/data/models/item_model.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getAllItems();

  Future<void> addItem(ItemModel item);

  Future<void> deleteItem(String itemId);
}
