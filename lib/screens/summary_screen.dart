import 'package:flutter/material.dart';

import '../models/category_total.dart';
import '../notifiers/app_notifier.dart';
import '../utils/category_icons.dart';
import '../utils/formatters.dart';

abstract final class _Strings {
  static const String title = 'Summary';
  static const String categoryBreakdown = 'Spending by category';
  static const String noExpensesThisMonth = 'No expenses this month.';
  static const String vsLastMonth = 'vs last month';
}

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.notifier});

  final AppNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_Strings.title)),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          final categoryTotals = notifier.currentMonthCategoryTotals;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonthComparisonCard(
                currentMonthTotal: notifier.currentMonthTotal,
                previousMonthTotal: notifier.previousMonthTotal,
              ),
              const SizedBox(height: 24),
              Text(
                _Strings.categoryBreakdown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (categoryTotals.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(_Strings.noExpensesThisMonth)),
                )
              else
                for (final categoryTotal in categoryTotals)
                  _CategoryTotalTile(categoryTotal: categoryTotal),
            ],
          );
        },
      ),
    );
  }
}

class _MonthComparisonCard extends StatelessWidget {
  const _MonthComparisonCard({
    required this.currentMonthTotal,
    required this.previousMonthTotal,
  });

  final double currentMonthTotal;
  final double previousMonthTotal;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1);
    final delta = currentMonthTotal - previousMonthTotal;
    final percentChange =
        previousMonthTotal == 0 ? null : (delta / previousMonthTotal) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _MonthTotalColumn(
                    label: monthNames[previousMonth.month - 1],
                    total: previousMonthTotal,
                  ),
                ),
                Expanded(
                  child: _MonthTotalColumn(
                    label: monthNames[now.month - 1],
                    total: currentMonthTotal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _ComparisonIndicator(delta: delta, percentChange: percentChange),
          ],
        ),
      ),
    );
  }
}

class _MonthTotalColumn extends StatelessWidget {
  const _MonthTotalColumn({required this.label, required this.total});

  final String label;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          formatCurrency(total),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class _ComparisonIndicator extends StatelessWidget {
  const _ComparisonIndicator(
      {required this.delta, required this.percentChange});

  final double delta;
  final double? percentChange;

  @override
  Widget build(BuildContext context) {
    final isIncrease = delta > 0;
    final isDecrease = delta < 0;
    final color = isIncrease
        ? Theme.of(context).colorScheme.error
        : isDecrease
            ? Colors.green
            : Theme.of(context).colorScheme.onSurfaceVariant;
    final icon = isIncrease
        ? Icons.arrow_upward
        : isDecrease
            ? Icons.arrow_downward
            : Icons.remove;
    final sign = isIncrease ? '+' : (isDecrease ? '-' : '');
    final percentText = percentChange == null
        ? ''
        : ' (${percentChange! > 0 ? '+' : ''}${percentChange!.toStringAsFixed(1)}%)';

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$sign${formatCurrency(delta.abs())}$percentText '
            '${_Strings.vsLastMonth}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTotalTile extends StatelessWidget {
  const _CategoryTotalTile({required this.categoryTotal});

  final CategoryTotal categoryTotal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(categoryIcons[categoryTotal.category]),
        ),
        title: Text(categoryTotal.category.label),
        trailing: Text(
          formatCurrency(categoryTotal.amount),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
