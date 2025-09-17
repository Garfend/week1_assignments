import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_model.dart';
import '../models/item_drink.dart';
import '../models/constants/order_status.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drinks (
            drinkId TEXT PRIMARY KEY,
            drinkName TEXT,
            drinkPrice REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE orders (
            orderId TEXT PRIMARY KEY,
            drinkId TEXT,
            customerName TEXT,
            specialInstructions TEXT,
            orderStatus TEXT,
            quantity INTEGER,
            total REAL,
            FOREIGN KEY(drinkId) REFERENCES drinks(drinkId)
          )
        ''');
      },
    );
  }

  // CRUD for drinks
  Future<void> insertDrink(ItemDrink drink) async {
    final db = await database;
    await db.insert('drinks', {
      'drinkId': drink.drinkId,
      'drinkName': drink.drinkName,
      'drinkPrice': drink.drinkPrice,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemDrink>> getAllDrinks() async {
    final db = await database;
    final maps = await db.query('drinks');
    return maps.map((m) => ItemDrink(
      drinkId: m['drinkId'] as String,
      drinkName: m['drinkName'] as String,
      drinkPrice: m['drinkPrice'] as double,
    )).toList();
  }

  // CRUD for orders
  Future<void> insertOrder(OrderModel order) async {
    final db = await database;
    await db.insert('orders', {
      'orderId': order.orderId,
      'drinkId': order.itemDrink.drinkId,
      'customerName': order.customerName,
      'specialInstructions': order.specialInstructions,
      'orderStatus': order.orderStatus.name,
      'quantity': order.quantity,
      'total': order.total,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT o.*, d.drinkName, d.drinkPrice
      FROM orders o
      JOIN drinks d ON o.drinkId = d.drinkId
    ''');
    return maps.map((m) => OrderModel(
      orderId: m['orderId'] as String,
      itemDrink: ItemDrink(
        drinkId: m['drinkId'] as String,
        drinkName: m['drinkName'] as String,
        drinkPrice: m['drinkPrice'] as double,
      ),
      customerName: m['customerName'] as String,
      specialInstructions: m['specialInstructions'] as String,
      orderStatus: OrderStatus.values.firstWhere((e) => e.name == m['orderStatus']),
      quantity: m['quantity'] as int,
      total: m['total'] as double,
    )).toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final db = await database;
    await db.update(
      'orders',
      {'orderStatus': status.name},
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }
}