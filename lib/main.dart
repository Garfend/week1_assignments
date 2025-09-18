import 'package:assignment1/data/repository/imp/daily_reports_repository_imp.dart';
import 'package:assignment1/data/repository/imp/order_repository_impl.dart';
import 'package:assignment1/ui/pages/dashboard.dart';
import 'package:assignment1/ui/pages/home_page.dart';
import 'package:assignment1/ui/pages/items_page.dart';
import 'package:assignment1/ui/widgets/app_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'data/repository/imp/item_repository_imp.dart';
import 'data/repository/imp/top_selling_reports_repository_imp.dart';
import 'domain/usecase/daily_reports_usecase.dart';
import 'domain/usecase/item_usecase.dart';
import 'domain/usecase/navigation_service.dart';
import 'domain/usecase/order_usecase.dart';
import 'domain/usecase/top_selling_reports_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final db = AppDatabase();
  final orderRepo = OrderRepositorySQLite();

  final orderService = OrderUsecase(orderRepo);
  final itemRepository = ItemRepositoryImp();
  final itemService = ItemUsecase(itemRepository);
  final allOrders = await orderService.getAllOrders();
  final dailyReportsRepository = DailyReportsRepositoryImp(allOrders);
  final reportsService = DailyReportsUsecase(dailyReportsRepository);
  final topSellingReportsService = TopSellingReportsUsecase(
      TopSellingReportsRepositoryImp(allOrders),);

      runApp(
        AhwaaApp(
          orderService: orderService,
          reportsService: reportsService,
          itemService: itemService,
          topSellingReportsService: topSellingReportsService,

        ),
      );
  }

class AhwaaApp extends StatelessWidget {
  final OrderUsecase orderService;
  final DailyReportsUsecase reportsService;
  final ItemUsecase itemService;
  final TopSellingReportsUsecase topSellingReportsService;


  const AhwaaApp({
    super.key,
    required this.orderService,
    required this.reportsService,
    required this.itemService,
    required this.topSellingReportsService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahwaa App',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MainScreen(
              orderService: orderService,
              reportsService: reportsService,
              itemService: itemService,
              topSellingReportsService: topSellingReportsService,
            ),
        '/dashboard': (context) =>
            DashboardPage(
              orderService: orderService,
            ),
        '/home': (context) =>
            HomePage(
              orderService: orderService,
              reportsService: reportsService,
              topSellingReportsService: topSellingReportsService,
            ),
        '/item': (context) => ItemsPage(itemService: itemService),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final OrderUsecase orderService;
  final DailyReportsUsecase reportsService;
  final ItemUsecase itemService;
  final TopSellingReportsUsecase topSellingReportsService;

  const MainScreen({
    super.key,
    required this.orderService,
    required this.reportsService,
    required this.itemService,
    required this.topSellingReportsService,

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
        topSellingReportsService: widget.topSellingReportsService,

      ),
      DashboardPage(
        orderService: widget.orderService,
      ),
      ItemsPage(itemService: widget.itemService),
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
