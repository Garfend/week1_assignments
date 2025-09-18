import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_model.dart';
import '../models/item_model.dart';
import '../models/constants/order_status.dart';

class AppDatasource {
  static final AppDatasource _instance = AppDatasource._internal();

  factory AppDatasource() => _instance;

  AppDatasource._internal();

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
      version: 3, // Increment version for schema change
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            itemId TEXT PRIMARY KEY,
            itemName TEXT,
            itemPrice REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE orders (
            orderId TEXT PRIMARY KEY,
            orderNumber INTEGER,
            itemId TEXT,
            customerName TEXT,
            specialInstructions TEXT,
            orderStatus TEXT,
            quantity INTEGER,
            total REAL,
            orderDate TEXT,
            FOREIGN KEY(itemId) REFERENCES items(itemId)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE orders ADD COLUMN orderDate TEXT');
          await db.execute('''
            UPDATE orders
            SET orderDate = ?
            WHERE orderDate IS NULL
          ''', [DateTime.now().toIso8601String()]);
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE orders ADD COLUMN orderNumber INTEGER');
          // Set order numbers for existing orders
          final orders = await db.query('orders', orderBy: 'orderId');
          for (int i = 0; i < orders.length; i++) {
            await db.update(
              'orders',
              {'orderNumber': i + 1},
              where: 'orderId = ?',
              whereArgs: [orders[i]['orderId']],
            );
          }
        }
      },
    );
  }

  // Generate next order number for today
  Future<int> _getNextOrderNumber() async {
    final db = await database;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day).toIso8601String();
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery('''
      SELECT MAX(orderNumber) as maxNumber
      FROM orders
      WHERE orderDate >= ? AND orderDate <= ?
    ''', [todayStart, todayEnd]);

    final maxNumber = result.first['maxNumber'] as int?;
    return (maxNumber ?? 0) + 1;
  }

  // CRUD for items
  Future<void> insertItem(ItemModel item) async {
    final db = await database;
    await db.insert('items', {
      'itemId': item.itemId,
      'itemName': item.itemName,
      'itemPrice': item.itemPrice,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemModel>> getAllItems() async {
    final db = await database;
    final maps = await db.query('items');
    return maps
        .map(
          (m) => ItemModel(
        itemId: m['itemId'] as String,
        itemName: m['itemName'] as String,
        itemPrice: (m['itemPrice'] as num).toDouble(),
      ),
    )
        .toList();
  }

  Future<void> deleteItem(String itemId) async {
    final db = await database;
    await db.delete('items', where: 'itemId = ?', whereArgs: [itemId]);
  }

  // CRUD for orders
  Future<void> insertOrder(OrderModel order) async {
    final db = await database;
    final orderNumber = await _getNextOrderNumber();

    await db.insert('orders', {
      'orderId': order.orderId,
      'orderNumber': orderNumber,
      'itemId': order.items.itemId,
      'customerName': order.customerName,
      'specialInstructions': order.specialInstructions,
      'orderStatus': order.orderStatus.name,
      'quantity': order.quantity,
      'total': order.total,
      'orderDate': order.orderDate.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteOrder(String orderId) async {
    final db = await database;
    await db.delete('orders', where: 'orderId = ?', whereArgs: [orderId]);
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT o.*, i.itemName, i.itemPrice
      FROM orders o
      JOIN items i ON o.itemId = i.itemId
    ''');
    return maps
        .map(
          (m) => OrderModel(
        orderId: m['orderId'] as String,
        orderNumber: (m['orderNumber'] as int?) ?? 1,
        items: ItemModel(
          itemId: m['itemId'] as String,
          itemName: m['itemName'] as String,
          itemPrice: (m['itemPrice'] as num).toDouble(),
        ),
        customerName: m['customerName'] as String,
        specialInstructions: m['specialInstructions'] as String,
        orderStatus: OrderStatus.values.firstWhere(
              (e) => e.name == m['orderStatus'],
        ),
        quantity: (m['quantity'] as num).toInt(),
        total: (m['total'] as num).toDouble(),
        orderDate: DateTime.parse(m['orderDate'] as String),
      ),
    )
        .toList();
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