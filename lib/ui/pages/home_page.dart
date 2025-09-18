import 'package:flutter/material.dart';

import '../../data/repository/imp/daily_reports_repository_imp.dart';
import '../../data/repository/imp/top_selling_reports_repository_imp.dart';
import '../../domain/usecase/daily_reports_usecase.dart';
import '../../domain/usecase/order_usecase.dart';
import '../../domain/usecase/top_selling_reports_usecase.dart';
import '../widgets/top_item_card.dart';
import '../widgets/total_sales_card.dart';

class HomePage extends StatefulWidget {
  final OrderUsecase orderService;
  final DailyReportsUsecase reportsService;
  final TopSellingReportsUsecase topSellingReportsService;

  const HomePage({
    super.key,
    required this.orderService,
    required this.reportsService,
    required this.topSellingReportsService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder(
        future: _buildFreshReportsData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final topItems = data['topItems'] as Map<String, int>;
          final sortedTopItems = topItems.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TotalSalesCard(
                        title: 'Daily Units',
                        value: data['totalItems'].toString(),
                      ),
                    ),
                    Expanded(
                      child: TotalSalesCard(
                        title: 'Daily Earned',
                        value: data['totalSales'].toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Top Items'),
                ...sortedTopItems.asMap().entries.map((e) => TopItemCard(
                  itemName: e.value.key,
                  soldCount: e.value.value,
                  index: e.key + 1,
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _buildFreshReportsData() async {
    final orders = await widget.orderService.getAllOrders();

    final dailyReports = DailyReportsRepositoryImp(orders);
    final topSellingReports = TopSellingReportsRepositoryImp(orders);

    return {
      'totalSales': dailyReports.totalSales(),
      'totalItems': dailyReports.totalItemsSold(),
      'topItems': topSellingReports.topSellingItems(),
    };
  }
}