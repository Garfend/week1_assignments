import 'package:flutter/material.dart';
import 'package:assignment1/ui/widgets/app_navigation_bar.dart';
import 'package:assignment1/logic/services/navigation_service.dart';
import 'package:assignment1/ui/pages/home_page.dart';
import 'package:assignment1/ui/pages/dashboard.dart';
import 'package:assignment1/data/models/order_model.dart';
import 'package:assignment1/data/models/item_drink.dart';
import 'package:assignment1/data/models/constants/order_status.dart';
import 'package:assignment1/data/repository/imp/order_repository_impl.dart';
import 'package:assignment1/data/repository/imp/daily_reports_repository_imp.dart';
import 'package:assignment1/logic/services/order_service.dart';
import 'package:assignment1/logic/services/daily_reports_service.dart';
import 'package:assignment1/data/local/app_database.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final orderRepo = OrderRepositorySQLite();

  final orderService = OrderService(orderRepo);
  final allOrders = await orderService.getAllOrders();
  final dailyReportsRepository = DailyReportsRepositoryImp(allOrders);
  final reportsService = DailyReportsService(dailyReportsRepository);

  runApp(AhwaaApp(
    orderService: orderService,
    reportsService: reportsService,
  ));
}

class AhwaaApp extends StatelessWidget {
  final OrderService orderService;
  final DailyReportsService reportsService;

  const AhwaaApp({
    super.key,
    required this.orderService,
    required this.reportsService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahwaa App',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(
          orderService: orderService,
          reportsService: reportsService,
        ),
        '/dashboard': (context) => DashboardPage(
          orderService: orderService,
          reportsService: reportsService,
        ),
        '/home': (context) => HomePage(
          orderService: orderService,
          reportsService: reportsService,
        ),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final OrderService orderService;
  final DailyReportsService reportsService;

  const MainScreen({
    super.key,
    required this.orderService,
    required this.reportsService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        orderService: widget.orderService,
        reportsService: widget.reportsService,
      ),
      DashboardPage(
        orderService: widget.orderService,
        reportsService: widget.reportsService,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}