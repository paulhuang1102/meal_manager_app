import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/meal_statistic_bloc.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealStatisticBloc, MealStatisticState>(
      builder: (context, state) {
        if (state is MealStatisticLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MealStatisticError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is! MealStatisticLoaded) {
          return const Center(child: Text('Unexpected state.'));
        }

        final statistics = state.statistics;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatisticCard(
                title: 'Breakfast',
                count: statistics.breakfastCount,
                icon: Icons.free_breakfast,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              _StatisticCard(
                title: 'Lunch',
                count: statistics.lunchCount,
                icon: Icons.lunch_dining,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _StatisticCard(
                title: 'Dinner',
                count: statistics.dinnerCount,
                icon: Icons.dinner_dining,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              _TotalCard(totalCount: statistics.totalCount),
            ],
          ),
        );
      },
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatisticCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int totalCount;

  const _TotalCard({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Meals Ordered',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '$totalCount',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
