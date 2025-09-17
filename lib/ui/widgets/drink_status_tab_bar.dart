import 'package:flutter/material.dart';

class DrinkStatusTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const DrinkStatusTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: onTabChanged,
      tabs: const [
        Tab(text: 'Pending'),
        Tab(text: 'In Progress'),
      ],
      indicatorColor: Theme.of(context).primaryColor,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey,
      controller: TabController(
        length: 2,
        vsync: Scaffold.of(context),
        initialIndex: selectedIndex,
      ),
    );
  }
}