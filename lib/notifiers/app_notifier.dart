import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../data/expense_repository.dart';
import '../models/category_total.dart';
import '../models/expense.dart';
import '../models/monthly_summary.dart';

/// Central state for the app.
class AppNotifier extends ChangeNotifier {
  AppNotifier(this._repository, {DateTime Function()? now})
      : _now = now ?? DateTime.now {
    // Defensively copy: callers shouldn't have to guarantee the
    // repository returns a fresh, mutable, unshared list.
    _expenses = List.of(_repository.loadInitialExpenses());
  }

  final ExpenseRepository _repository;

  /// Injectable clock so time-dependent logic (e.g. [monthlySummary]) can
  /// be unit tested with a fixed point in time instead of the wall clock.
  final DateTime Function() _now;

  late final List<Expense> _expenses;

  List<Expense> get expenses => UnmodifiableListView(_expenses);

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  // ---- Filtering ----

  ExpenseCategory? _selectedCategory;

  ExpenseCategory? get selectedCategory => _selectedCategory;

  List<Expense> get filteredExpenses {
    final expenses = _selectedCategory == null
        ? _expenses
        : _expenses.where((e) => e.category == _selectedCategory);
    return UnmodifiableListView(expenses);
  }

  double get total => _totalOf(filteredExpenses);

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

  List<CategoryTotal> _categoryTotalsOf(Iterable<Expense> expenses) {
    final totals = <ExpenseCategory, double>{};
    for (final expense in expenses) {
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

  MonthlySummary get monthlySummary {
    final now = _now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);
    final currentMonthExpenses = _expensesInMonth(currentMonth);

    return MonthlySummary(
      currentMonth: currentMonth,
      previousMonth: previousMonth,
      currentMonthTotal: _totalOf(currentMonthExpenses),
      previousMonthTotal: _totalOf(_expensesInMonth(previousMonth)),
      categoryTotals: _categoryTotalsOf(currentMonthExpenses),
    );
  }

  // ---- New expense form ----

  /// Validates and adds a new expense. Returns false when [title] or
  /// [amount] are not valid, in which case nothing is added.
  bool addExpense({
    required String title,
    required String amount,
    required ExpenseCategory category,
  }) {
    final trimmedTitle = title.trim();
    final parsedAmount = double.tryParse(amount.replaceAll(',', '.'));
    if (trimmedTitle.isEmpty || parsedAmount == null || parsedAmount <= 0) {
      return false;
    }
    _expenses.insert(
      0,
      Expense(
        id: _now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
        amount: parsedAmount,
        category: category,
        date: _now(),
      ),
    );
    notifyListeners();
    return true;
  }
}
