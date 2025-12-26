import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../person/domain/entities/person.dart';
import '../../../person/presentation/bloc/person_bloc.dart';
import '../../../person/presentation/bloc/person_state.dart';
import '../../domain/entities/meal_order.dart';
import '../bloc/meal_order_bloc.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, personState) {
        if (personState is PersonLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (personState is PersonError) {
          return Center(child: Text('Error: ${personState.message}'));
        }

        if (personState is! PersonLoaded) {
          return const Center(child: Text('Unexpected state.'));
        }

        final persons = personState.persons;

        if (persons.isEmpty) {
          return const Center(child: Text('No persons available.'));
        }

        return BlocBuilder<MealOrderBloc, MealOrderState>(
          builder: (context, orderState) {
            if (orderState is MealOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (orderState is MealOrderError) {
              return Center(child: Text('Error: ${orderState.message}'));
            }

            final orders = orderState is MealOrderLoaded ? orderState.orders : <MealOrder>[];

            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return _PersonOrderItem(
                  person: person,
                  orders: orders,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _PersonOrderItem extends StatelessWidget {
  final Person person;
  final List<MealOrder> orders;

  const _PersonOrderItem({
    required this.person,
    required this.orders,
  });

  bool _isOrdered(MealType mealType) {
    return orders.any(
      (order) => order.personId == person.id && order.mealType == mealType,
    );
  }

  void _toggleMeal(BuildContext context, MealType mealType) {
    context.read<MealOrderBloc>().add(
          MealOrderToggleEvent(
            personId: person.id,
            personName: person.name,
            mealType: mealType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _MealCheckbox(
                  label: 'Breakfast',
                  mealType: MealType.breakfast,
                  isChecked: _isOrdered(MealType.breakfast),
                  onChanged: () => _toggleMeal(context, MealType.breakfast),
                ),
                _MealCheckbox(
                  label: 'Lunch',
                  mealType: MealType.lunch,
                  isChecked: _isOrdered(MealType.lunch),
                  onChanged: () => _toggleMeal(context, MealType.lunch),
                ),
                _MealCheckbox(
                  label: 'Dinner',
                  mealType: MealType.dinner,
                  isChecked: _isOrdered(MealType.dinner),
                  onChanged: () => _toggleMeal(context, MealType.dinner),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCheckbox extends StatelessWidget {
  final String label;
  final MealType mealType;
  final bool isChecked;
  final VoidCallback onChanged;

  const _MealCheckbox({
    required this.label,
    required this.mealType,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isChecked,
      onSelected: (_) => onChanged(),
      checkmarkColor: Colors.white,
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isChecked ? Colors.white : null,
      ),
    );
  }
}
