import '../models/expense.dart';

/// Provides the initial set of expenses.
///
/// In a real app this would talk to a database or an API. For now it
/// returns an in-memory seed so the app has something to show.
class ExpenseRepository {
  List<Expense> loadInitialExpenses() {
    final now = DateTime.now();
    return [
      Expense(
        id: 'e1',
        title: 'Groceries',
        amount: 54.30,
        category: ExpenseCategory.food,
        date: DateTime(now.year, now.month, now.day - 1),
      ),
      Expense(
        id: 'e2',
        title: 'Metro card top-up',
        amount: 20.00,
        category: ExpenseCategory.transport,
        date: DateTime(now.year, now.month, now.day - 2),
      ),
      Expense(
        id: 'e3',
        title: 'Electricity bill',
        amount: 78.90,
        category: ExpenseCategory.bills,
        date: DateTime(now.year, now.month, now.day - 3),
      ),
      Expense(
        id: 'e4',
        title: 'Cinema tickets',
        amount: 24.00,
        category: ExpenseCategory.entertainment,
        date: DateTime(now.year, now.month, now.day - 4),
      ),
      Expense(
        id: 'e5',
        title: 'Lunch with team',
        amount: 31.50,
        category: ExpenseCategory.food,
        date: DateTime(now.year, now.month, now.day - 5),
      ),
      Expense(
        id: 'e6',
        title: 'Running shoes',
        amount: 89.99,
        category: ExpenseCategory.shopping,
        date: DateTime(now.year, now.month - 1, 24),
      ),
      Expense(
        id: 'e7',
        title: 'Internet bill',
        amount: 39.00,
        category: ExpenseCategory.bills,
        date: DateTime(now.year, now.month - 1, 18),
      ),
      Expense(
        id: 'e8',
        title: 'Taxi to airport',
        amount: 42.75,
        category: ExpenseCategory.transport,
        date: DateTime(now.year, now.month - 1, 12),
      ),
      Expense(
        id: 'e9',
        title: 'Birthday gift',
        amount: 35.00,
        category: ExpenseCategory.shopping,
        date: DateTime(now.year, now.month - 1, 9),
      ),
      Expense(
        id: 'e10',
        title: 'Coffee beans',
        amount: 14.25,
        category: ExpenseCategory.food,
        date: DateTime(now.year, now.month - 1, 5),
      ),
    ];
  }
}
