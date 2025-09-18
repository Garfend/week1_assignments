import 'package:flutter/material.dart';
import '../../data/repository/imp/overall_reports_repository_imp.dart';
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
      appBar: AppBar(
        title: const Text('Smart Ahwa Manager'),
      ),
      body: FutureBuilder(
        future: _buildOverallReportsData(),
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
                        title: 'Total Units Sold',
                        value: data['totalItems'].toString(),
                      ),
                    ),
                    Expanded(
                      child: TotalSalesCard(
                        title: 'Total Revenue',
                        value: '\$${data['totalSales'].toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                    'Top Selling Items (All Time)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                if (sortedTopItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No sales data available yet'),
                  )
                else
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

  Future<Map<String, dynamic>> _buildOverallReportsData() async {
    final orders = await widget.orderService.getAllOrders();

    // Use new SOLID-compliant repository
    final overallReports = OverallReportsRepository(orders);
    final topSellingReports = TopSellingReportsRepositoryImp(orders);

    return {
      'totalSales': overallReports.totalSales(),
      'totalItems': overallReports.totalItemsSold(),
      'topItems': topSellingReports.topSellingItems(),
    };
  }
}