import 'package:flutter/foundation.dart';

import '../data/expense_repository.dart';
import '../models/category_total.dart';
import '../models/expense.dart';

/// Central state for the app.
class AppNotifier extends ChangeNotifier {
  AppNotifier(this._repository) {
    _expenses = _repository.loadInitialExpenses();
  }

  final ExpenseRepository _repository;

  late final List<Expense> _expenses;

  List<Expense> get expenses => List.unmodifiable(_expenses);

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  // ---- Filtering ----

  ExpenseCategory? _selectedCategory;

  ExpenseCategory? get selectedCategory => _selectedCategory;

  List<Expense> get filteredExpenses {
    if (_selectedCategory == null) {
      return _expenses;
    }
    return _expenses.where((e) => e.category == _selectedCategory).toList();
  }

  double get total {
    var sum = 0.0;
    for (final expense in filteredExpenses) {
      sum += expense.amount;
    }
    return sum;
  }

  void selectCategory(ExpenseCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ---- Summary ----

  List<Expense> _expensesInMonth(DateTime month) {
    return _expenses
        .where(
          (e) => e.date.year == month.year && e.date.month == month.month,
        )
        .toList();
  }

  double _totalOf(Iterable<Expense> expenses) =>
      expenses.fold(0.0, (sum, expense) => sum + expense.amount);

  double get currentMonthTotal => _totalOf(_expensesInMonth(DateTime.now()));

  double get previousMonthTotal {
    final now = DateTime.now();
    return _totalOf(_expensesInMonth(DateTime(now.year, now.month - 1)));
  }

  /// Per-category totals for the current month, sorted by amount descending.
  /// Categories with no spending this month are omitted.
  List<CategoryTotal> get currentMonthCategoryTotals {
    final totals = <ExpenseCategory, double>{};
    for (final expense in _expensesInMonth(DateTime.now())) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return [
      for (final entry in totals.entries)
        CategoryTotal(category: entry.key, amount: entry.value),
    ]..sort((a, b) => b.amount.compareTo(a.amount));
  }

  // ---- Theme ----

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ---- New expense form ----

  String draftTitle = '';
  String draftAmount = '';
  ExpenseCategory draftCategory = ExpenseCategory.other;

  void updateDraftTitle(String value) {
    draftTitle = value;
    notifyListeners();
  }

  void updateDraftAmount(String value) {
    draftAmount = value;
    notifyListeners();
  }

  void updateDraftCategory(ExpenseCategory value) {
    draftCategory = value;
    notifyListeners();
  }

  /// Adds the drafted expense to the list. Returns false when the draft
  /// is not valid.
  bool submitDraft() {
    final title = draftTitle.trim();
    final amount = double.tryParse(draftAmount.replaceAll(',', '.'));
    if (title.isEmpty || amount == null || amount <= 0) {
      return false;
    }
    _expenses.insert(
      0,
      Expense(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        category: draftCategory,
        date: DateTime.now(),
      ),
    );
    draftTitle = '';
    draftAmount = '';
    draftCategory = ExpenseCategory.other;
    notifyListeners();
    return true;
  }
}
