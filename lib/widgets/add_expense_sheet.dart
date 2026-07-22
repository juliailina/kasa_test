import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../notifiers/app_notifier.dart';

class AddExpenseSheet extends StatelessWidget {
  const AddExpenseSheet({super.key, required this.notifier});

  final AppNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
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
              Text(
                'New expense',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: notifier.draftTitle,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onChanged: notifier.updateDraftTitle,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: notifier.draftAmount,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: notifier.updateDraftAmount,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExpenseCategory>(
                initialValue: notifier.draftCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
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
                    notifier.updateDraftCategory(value);
                  }
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  final added = notifier.submitDraft();
                  if (added) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter a title and a valid amount.'),
                      ),
                    );
                  }
                },
                child: const Text('Add expense'),
              ),
            ],
          ),
        );
      },
    );
  }
}
