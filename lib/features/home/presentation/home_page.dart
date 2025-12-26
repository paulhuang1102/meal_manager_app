import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_event.dart';
import '../../person/presentation/bloc/person_bloc.dart';
import '../../person/presentation/bloc/person_event.dart';
import '../../person/presentation/widgets/add_person_floating_button.dart';
import '../../person/presentation/widgets/person_list.dart';
import '../../meal_order/presentation/pages/meal_order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PersonBloc>().add(PersonLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const _HomePageContent();
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  void _navigateToMealOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MealOrderPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant),
            onPressed: () => _navigateToMealOrder(context),
            tooltip: 'Meal Order',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: PresonList(),
      floatingActionButton: const AddPersonFloatingButton(),
    );
  }
}
