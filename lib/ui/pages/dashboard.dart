import 'package:flutter/material.dart';
import '../../data/models/constants/order_status.dart';
import '../../data/repository/imp/daily_reports_repository_imp.dart';
import '../../domain/usecase/daily_reports_usecase.dart';
import '../../domain/usecase/order_usecase.dart';
import '../widgets/add_new_order/add_new_order_bottomsheet.dart';
import '../widgets/total_sales_card.dart';
import '../widgets/order_card.dart';

class DashboardPage extends StatefulWidget {
  final OrderUsecase orderService;

  const DashboardPage({
    super.key,
    required this.orderService,
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

          // Create fresh reports service with current orders
          final reportsService = DailyReportsUsecase(
              DailyReportsRepositoryImp(orders)
          );

          final pendingOrders = orders.where((o) => o.orderStatus == OrderStatus.pending).toList();
          final inProgressOrders = orders.where((o) => o.orderStatus == OrderStatus.inProgress).toList();

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TotalSalesCard(
                      title: 'Total Units',
                      value: reportsService.totalItemsSold().toString(),
                    ),
                  ),
                  Expanded(
                    child: TotalSalesCard(
                      title: 'Total Earned',
                      value: reportsService.totalSales().toStringAsFixed(2),
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
                      children: pendingOrders.map((order) => OrderCard(
                        order: order,
                        orderService: widget.orderService,
                        onUpdateStatus: () async {
                          await widget.orderService.updateOrderStatus(order.orderId, OrderStatus.inProgress);
                          await _refresh();
                        },
                        onOrderDeleted: _refresh,
                      )).toList(),
                    ),
                    ListView(
                      children: inProgressOrders.map((order) => OrderCard(
                        order: order,
                        orderService: widget.orderService,
                        onUpdateStatus: () async {
                          await widget.orderService.updateOrderStatus(order.orderId, OrderStatus.complete);
                          await _refresh();
                        },
                        onOrderDeleted: _refresh,
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
              orderService: widget.orderService,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}