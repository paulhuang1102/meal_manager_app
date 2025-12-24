import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_event.dart';
import '../bloc/person_state.dart';
import '../pages/person_form_page.dart';
import 'person_filter_sheet.dart';

class PresonList extends StatefulWidget {
  const PresonList({super.key});

  @override
  State<PresonList> createState() => _PresonListState();
}

class _PresonListState extends State<PresonList> {
  String? _filterName;
  int? _filterMinAge;
  int? _filterMaxAge;
  int? _filterBirthMonth;

  bool get _hasActiveFilters {
    return _filterName != null ||
        _filterMinAge != null ||
        _filterMaxAge != null ||
        _filterBirthMonth != null;
  }

  void _showFilterSheet() {
    // Capture the correct context that has access to PersonBloc
    final blocContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => PersonFilterSheet(
        initialName: _filterName,
        initialMinAge: _filterMinAge,
        initialMaxAge: _filterMaxAge,
        initialBirthMonth: _filterBirthMonth,
        onApply: (name, minAge, maxAge, birthMonth) {
          setState(() {
            _filterName = name;
            _filterMinAge = minAge;
            _filterMaxAge = maxAge;
            _filterBirthMonth = birthMonth;
          });

          if (name != null ||
              minAge != null ||
              maxAge != null ||
              birthMonth != null) {
            blocContext.read<PersonBloc>().add(
                  PersonSearchEvent(
                    name: name,
                    minAge: minAge,
                    maxAge: maxAge,
                    birthMonth: birthMonth,
                  ),
                );
          } else {
            blocContext.read<PersonBloc>().add(PersonClearSearchEvent());
          }
        },
        onClear: () {
          setState(() {
            _filterName = null;
            _filterMinAge = null;
            _filterMaxAge = null;
            _filterBirthMonth = null;
          });
          blocContext.read<PersonBloc>().add(PersonClearSearchEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonBloc, PersonState>(
      listener: (context, state) {
        if (state is PersonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is PersonOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            // Filter bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: state is PersonLoaded
                        ? Text(
                            _hasActiveFilters
                                ? '${state.persons.length} person${state.persons.length != 1 ? 's' : ''} found'
                                : '${state.persons.length} person${state.persons.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_hasActiveFilters)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _filterName = null;
                            _filterMinAge = null;
                            _filterMaxAge = null;
                            _filterBirthMonth = null;
                          });
                          context
                              .read<PersonBloc>()
                              .add(PersonClearSearchEvent());
                        },
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('Clear'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Badge(
                      isLabelVisible: _hasActiveFilters,
                      label: Text(_getFilterCount().toString()),
                      child: const Icon(Icons.filter_list),
                    ),
                    onPressed: _showFilterSheet,
                    tooltip: 'Filter',
                  ),
                ],
              ),
            ),

            // List content
            Expanded(
              child: _buildListContent(state),
            ),
          ],
        );
      },
    );
  }

  int _getFilterCount() {
    int count = 0;
    if (_filterName != null) count++;
    if (_filterMinAge != null || _filterMaxAge != null) count++;
    if (_filterBirthMonth != null) count++;
    return count;
  }

  Widget _buildListContent(PersonState state) {
    if (state is PersonLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PersonLoaded) {
      if (state.persons.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _hasActiveFilters ? Icons.search_off : Icons.people_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _hasActiveFilters
                    ? 'No persons match the filters'
                    : 'No persons yet',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                _hasActiveFilters
                    ? 'Try adjusting your filters'
                    : 'Tap + to add a new person',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          if (_hasActiveFilters) {
            context.read<PersonBloc>().add(
                  PersonSearchEvent(
                    name: _filterName,
                    minAge: _filterMinAge,
                    maxAge: _filterMaxAge,
                    birthMonth: _filterBirthMonth,
                  ),
                );
          } else {
            context.read<PersonBloc>().add(PersonLoadEvent());
          }
        },
        child: ListView.builder(
          itemCount: state.persons.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final person = state.persons[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    person.name.isNotEmpty
                        ? person.name[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(
                  person.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Age: ${person.age}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Birthday: ${DateFormat('yyyy-MM-dd').format(person.birthday)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<PersonBloc>(),
                              child: PersonFormPage(person: person),
                            ),
                          ),
                        );
                      },
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: Colors.red,
                      onPressed: () {
                        _showDeleteDialog(
                          context,
                          person.id,
                          person.name,
                        );
                      },
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      );
    }

    return const Center(child: Text('Something went wrong'));
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Person'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<PersonBloc>().add(PersonDeleteEvent(id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
