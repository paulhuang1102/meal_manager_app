import 'package:flutter/material.dart';

class PersonFilterSheet extends StatefulWidget {
  final String? initialName;
  final int? initialMinAge;
  final int? initialMaxAge;
  final int? initialBirthMonth;
  final Function(String? name, int? minAge, int? maxAge, int? birthMonth)
      onApply;
  final VoidCallback onClear;

  const PersonFilterSheet({
    super.key,
    this.initialName,
    this.initialMinAge,
    this.initialMaxAge,
    this.initialBirthMonth,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<PersonFilterSheet> createState() => _PersonFilterSheetState();
}

class _PersonFilterSheetState extends State<PersonFilterSheet> {
  late TextEditingController _nameController;
  late TextEditingController _minAgeController;
  late TextEditingController _maxAgeController;
  int? _selectedBirthMonth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _minAgeController = TextEditingController(
      text: widget.initialMinAge?.toString() ?? '',
    );
    _maxAgeController = TextEditingController(
      text: widget.initialMaxAge?.toString() ?? '',
    );
    _selectedBirthMonth = widget.initialBirthMonth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  bool get _hasAnyFilter {
    return _nameController.text.isNotEmpty ||
        _minAgeController.text.isNotEmpty ||
        _maxAgeController.text.isNotEmpty ||
        _selectedBirthMonth != null;
  }

  void _handleClear() {
    _nameController.clear();
    _minAgeController.clear();
    _maxAgeController.clear();
    setState(() {
      _selectedBirthMonth = null;
    });
    widget.onClear();
    Navigator.of(context).pop();
  }

  void _handleApply() {
    final minAge = _minAgeController.text.isEmpty
        ? null
        : int.tryParse(_minAgeController.text);
    final maxAge = _maxAgeController.text.isEmpty
        ? null
        : int.tryParse(_maxAgeController.text);

    widget.onApply(
      _nameController.text.isEmpty ? null : _nameController.text,
      minAge,
      maxAge,
      _selectedBirthMonth,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          _buildFilterContent(),
          const Divider(height: 1),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Filter Persons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameFilter(),
          const SizedBox(height: 24),
          _buildAgeRangeFilter(),
          const SizedBox(height: 24),
          _buildBirthMonthFilter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNameFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter name to search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: _nameController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: _nameController.clear,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Age Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min Age',
                  hintText: 'No min',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _minAgeController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _minAgeController.clear,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Age',
                  hintText: 'No max',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _maxAgeController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _maxAgeController.clear,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBirthMonthFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Birth Month',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select month',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedBirthMonth,
              isExpanded: true,
              hint: const Text('All months'),
              items: _buildMonthItems(),
              onChanged: (value) {
                setState(() {
                  _selectedBirthMonth = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _buildMonthItems() {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return [
      const DropdownMenuItem(
        value: null,
        child: Text('All months'),
      ),
      ...List.generate(
        12,
        (index) {
          final month = index + 1;
          return DropdownMenuItem(
            value: month,
            child: Text('$month - ${monthNames[index]}'),
          );
        },
      ),
    ];
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _hasAnyFilter ? _handleClear : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Clear All'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleApply,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_hasAnyFilter ? 'Apply Filters' : 'Show All'),
            ),
          ),
        ],
      ),
    );
  }
}
