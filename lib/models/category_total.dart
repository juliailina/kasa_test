import 'expense.dart';

/// The total amount spent in a single [ExpenseCategory] over some period.
class CategoryTotal {
  const CategoryTotal({required this.category, required this.amount});

  final ExpenseCategory category;
  final double amount;
}
