import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/person_bloc.dart';
import '../pages/person_form_page.dart';

class AddPersonFloatingButton extends StatelessWidget {
  const AddPersonFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PersonBloc>(),
              child: const PersonFormPage(),
            ),
          ),
        );
      },
      tooltip: 'Add Person',
      child: const Icon(Icons.add),
    );
  }
}
