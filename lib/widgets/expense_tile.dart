import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/category_icons.dart';
import '../utils/formatters.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(categoryIcons[expense.category]),
      ),
      title: Text(expense.title),
      subtitle: Text(
        '${expense.category.label} · ${formatShortDate(expense.date)}',
      ),
      trailing: Text(
        formatCurrency(expense.amount),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
