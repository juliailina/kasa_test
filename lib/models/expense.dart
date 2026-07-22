enum ExpenseCategory {
  food('Food'),
  transport('Transport'),
  shopping('Shopping'),
  bills('Bills'),
  entertainment('Entertainment'),
  other('Other');

  const ExpenseCategory(this.label);

  final String label;
}

class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
}
