import 'package:assignment1/data/models/item_model.dart';
import 'package:assignment1/data/repository/item_repository.dart';

class ItemUsecase {
  final ItemRepository repository;

  ItemUsecase(this.repository);

  Future<List<ItemModel>> getAllItems() => repository.getAllItems();

  Future<void> addItem(ItemModel item) => repository.addItem(item);

  Future<void> deleteItem(String itemId) => repository.deleteItem(itemId);


}
