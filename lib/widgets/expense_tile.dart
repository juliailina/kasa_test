import 'package:flutter/material.dart';

import '../models/expense.dart';

const _monthShortNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _categoryIcons = {
  ExpenseCategory.food: Icons.restaurant,
  ExpenseCategory.transport: Icons.directions_bus,
  ExpenseCategory.shopping: Icons.shopping_bag,
  ExpenseCategory.bills: Icons.receipt_long,
  ExpenseCategory.entertainment: Icons.movie,
  ExpenseCategory.other: Icons.category,
};

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense});

  final Expense expense;

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthShortNames[date.month - 1]}';
  }

  String _formatAmount(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(_categoryIcons[expense.category]),
      ),
      title: Text(expense.title),
      subtitle: Text(
        '${expense.category.label} · ${_formatDate(expense.date)}',
      ),
      trailing: Text(
        _formatAmount(expense.amount),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
