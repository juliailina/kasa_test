import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../notifiers/app_notifier.dart';

abstract final class _Strings {
  static const String title = 'New expense';
  static const String titleLabel = 'Title';
  static const String amountLabel = 'Amount';
  static const String categoryLabel = 'Category';
  static const String submit = 'Add expense';
  static const String invalidDraft = 'Please enter a title and a valid amount.';
}

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key, required this.notifier});

  final AppNotifier notifier;

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.other;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final added = widget.notifier.addExpense(
      title: _titleController.text,
      amount: _amountController.text,
      category: _category,
    );
    if (added) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_Strings.invalidDraft)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_Strings.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: _Strings.titleLabel,
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: _Strings.amountLabel,
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ExpenseCategory>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: _Strings.categoryLabel,
              border: OutlineInputBorder(),
            ),
            items: [
              for (final category in ExpenseCategory.values)
                DropdownMenuItem(
                  value: category,
                  child: Text(category.label),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _category = value);
              }
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submit,
            child: const Text(_Strings.submit),
          ),
        ],
      ),
    );
  }
}
