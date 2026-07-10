import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../notifiers/app_notifier.dart';
import '../widgets/add_expense_sheet.dart';
import '../widgets/expense_tile.dart';

const _monthNames = [
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

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key, required this.notifier});

  final AppNotifier notifier;

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpenseSheet(notifier: notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasa'),
        actions: [
          IconButton(
            onPressed: notifier.toggleDarkMode,
            icon: Icon(
              notifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          final expenses = notifier.filteredExpenses;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TotalHeader(total: notifier.total),
              _CategoryFilterRow(notifier: notifier),
              const Divider(height: 1),
              Expanded(
                child: expenses.isEmpty
                    ? const Center(child: Text('No expenses yet.'))
                    : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return Dismissible(
                            key: ValueKey(expense.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Theme.of(context).colorScheme.error,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              notifier.expenses.remove(expense);
                            },
                            child: ExpenseTile(expense: expense),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TotalHeader extends StatelessWidget {
  const _TotalHeader({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_monthNames[now.month - 1]} ${now.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({required this.notifier});

  final AppNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: const Text('All'),
              selected: notifier.selectedCategory == null,
              onSelected: (_) => notifier.selectCategory(null),
            ),
          ),
          for (final category in ExpenseCategory.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(category.label),
                selected: notifier.selectedCategory == category,
                onSelected: (_) => notifier.selectCategory(category),
              ),
            ),
        ],
      ),
    );
  }
}
