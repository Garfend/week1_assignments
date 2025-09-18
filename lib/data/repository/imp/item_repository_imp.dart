import 'package:assignment1/data/local/app_datasource.dart';
import 'package:assignment1/data/models/item_model.dart';
import 'package:assignment1/data/repository/item_repository.dart';

class ItemRepositoryImp implements ItemRepository {
  final AppDatasource _db = AppDatasource();

  @override
  Future<List<ItemModel>> getAllItems() => _db.getAllItems();

  @override
  Future<void> addItem(ItemModel item) => _db.insertItem(item);

  @override
  Future<void> deleteItem(String itemId) => _db.deleteItem(itemId);
}
