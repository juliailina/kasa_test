import 'package:flutter_test/flutter_test.dart';
import 'package:kasa/data/expense_repository.dart';

void main() {
  final repository = ExpenseRepository();

  group('ExpenseRepository', () {
    test('returns a non-empty list of expenses', () {
      expect(repository.loadInitialExpenses(), isNotEmpty);
    });

    test('every expense has a unique id', () {
      final expenses = repository.loadInitialExpenses();
      final ids = expenses.map((e) => e.id).toSet();

      expect(ids.length, expenses.length);
    });

    test('every expense has a positive amount', () {
      final expenses = repository.loadInitialExpenses();

      expect(expenses.every((e) => e.amount > 0), isTrue);
    });

    test('covers more than one category', () {
      final expenses = repository.loadInitialExpenses();
      final categories = expenses.map((e) => e.category).toSet();

      expect(categories.length, greaterThan(1));
    });
  });
}
