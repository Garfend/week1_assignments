import 'package:flutter/material.dart';
import '../../data/models/constants/order_status.dart';
import '../../logic/services/order_service.dart';
import '../../logic/services/daily_reports_service.dart';
import '../widgets/total_sales_card.dart';
import '../widgets/drink_card.dart';

class HomePage extends StatefulWidget {
  final OrderService orderService;
  final DailyReportsService reportsService;

  const HomePage({
    super.key,
    required this.orderService,
    required this.reportsService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<void> _refresh() async {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder(
        future: widget.orderService.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          final completedOrders = orders.where((o) => o.orderStatus == OrderStatus.complete).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TotalSalesCard(
                        title: 'Daily Units',
                        value: widget.reportsService.totalItemsSold().toString(),
                      ),
                    ),
                    Expanded(
                      child: TotalSalesCard(
                        title: 'Daily Earned',
                        value: widget.reportsService.totalSales().toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Completed Orders'),
                ...completedOrders.map((order) => DrinkCard(order: order)),
              ],
            ),
          );
        },
      ),
    );
  }
}