import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/meal_order_bloc.dart';
import '../bloc/meal_statistic_bloc.dart';
import '../widgets/order_tab.dart';
import '../widgets/statistics_tab.dart';

class MealOrderPage extends StatefulWidget {
  const MealOrderPage({super.key});

  @override
  State<MealOrderPage> createState() => _MealOrderPageState();
}

class _MealOrderPageState extends State<MealOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    context.read<MealOrderBloc>().add(MealOrderLoadEvent());
    context.read<MealStatisticBloc>().add(MealStatisticLoadEvent());
  }

  void _onTabChanged() {
    if (_tabController.index == 1) {
      context.read<MealStatisticBloc>().add(MealStatisticLoadEvent());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Manager'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.restaurant_menu),
              text: 'Order',
            ),
            Tab(
              icon: Icon(Icons.analytics),
              text: 'Statistics',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderTab(),
          StatisticsTab(),
        ],
      ),
    );
  }
}
