import 'package:flutter/material.dart';
import '../../data/models/constants/order_status.dart';
import '../../logic/services/order_service.dart';
import '../../logic/services/daily_reports_service.dart';
import '../widgets/add_new_order_bottomsheet.dart';
import '../widgets/total_sales_card.dart';
import '../widgets/drink_card.dart';

class DashboardPage extends StatefulWidget {
  final OrderService orderService;
  final DailyReportsService reportsService;

  const DashboardPage({
    super.key,
    required this.orderService,
    required this.reportsService,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder(
        future: widget.orderService.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          final pendingOrders = orders.where((o) => o.orderStatus == OrderStatus.pending).toList();
          final inProgressOrders = orders.where((o) => o.orderStatus == OrderStatus.inProgress).toList();

          // final updatedReportsService = DailyReportsService(
          //   widget.reportsService.reportsRepository.runtimeType == widget.reportsService.reportsRepository.runtimeType
          //       ? widget.reportsService.reportsRepository
          //       : widget.reportsService.reportsRepository,
          // );

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TotalSalesCard(
                      title: 'Total Units',
                      value: widget.reportsService.totalItemsSold().toString(),
                    ),
                  ),
                  Expanded(
                    child: TotalSalesCard(
                      title: 'Total Earned',
                      value: widget.reportsService.totalSales().toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'In Progress'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      children: pendingOrders.map((order) => DrinkCard(
                        order: order,
                        onUpdateStatus: () async {
                          await widget.orderService.updateOrderStatus(order.orderId, OrderStatus.inProgress);
                          await _refresh();
                        },
                      )).toList(),
                    ),
                    ListView(
                      children: inProgressOrders.map((order) => DrinkCard(
                        order: order,
                        onUpdateStatus: () async {
                          await widget.orderService.updateOrderStatus(order.orderId, OrderStatus.complete);
                          await _refresh();
                        },
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddNewOrderBottomSheet(
              onOrderAdded: _refresh,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}