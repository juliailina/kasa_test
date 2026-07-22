import 'package:flutter_test/flutter_test.dart';
import 'package:kasa/data/expense_repository.dart';
import 'package:kasa/models/expense.dart';
import 'package:kasa/notifiers/app_notifier.dart';

class _FakeExpenseRepository extends ExpenseRepository {
  _FakeExpenseRepository([this._seed = const []]);

  final List<Expense> _seed;

  @override
  List<Expense> loadInitialExpenses() => _seed;
}

Expense _expense({
  required String id,
  double amount = 1,
  ExpenseCategory category = ExpenseCategory.other,
  required DateTime date,
}) {
  return Expense(
      id: id, title: id, amount: amount, category: category, date: date);
}

AppNotifier _buildNotifier(
    {List<Expense> seed = const [], required DateTime now}) {
  return AppNotifier(_FakeExpenseRepository(seed), now: () => now);
}

void main() {
  test('loads seed expenses from the real repository', () {
    final notifier = AppNotifier(ExpenseRepository());

    expect(notifier.expenses, isNotEmpty);
    expect(notifier.selectedCategory, isNull);
    expect(notifier.filteredExpenses.length, notifier.expenses.length);
  });

  group('filtering and totals', () {
    test('selecting a category notifies listeners', () {
      final notifier = _buildNotifier(now: DateTime(2026, 3, 15));
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.selectCategory(ExpenseCategory.transport);

      expect(notified, isTrue);
    });

    test('total sums only the currently filtered expenses', () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [
          _expense(
              id: '1',
              amount: 10,
              category: ExpenseCategory.food,
              date: DateTime(2026, 3, 1)),
          _expense(
              id: '2',
              amount: 20,
              category: ExpenseCategory.transport,
              date: DateTime(2026, 3, 2)),
        ],
      );

      expect(notifier.total, 30);

      notifier.selectCategory(ExpenseCategory.food);
      expect(notifier.filteredExpenses.length, 1);
      expect(notifier.total, 10);

      notifier.selectCategory(null);
      expect(notifier.total, 30);
    });

    test('expenses and filteredExpenses cannot be mutated by callers', () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [_expense(id: '1', date: DateTime(2026, 3, 1))],
      );

      expect(
        () => notifier.expenses
            .add(_expense(id: '2', date: DateTime(2026, 3, 1))),
        throwsUnsupportedError,
      );
      expect(
        () => notifier.filteredExpenses
            .add(_expense(id: '2', date: DateTime(2026, 3, 1))),
        throwsUnsupportedError,
      );
    });
  });

  group('addExpense', () {
    test('rejects a blank title', () {
      final notifier = _buildNotifier(now: DateTime(2026, 3, 15));

      final added = notifier.addExpense(
        title: '   ',
        amount: '10',
        category: ExpenseCategory.food,
      );

      expect(added, isFalse);
      expect(notifier.expenses, isEmpty);
    });

    test('rejects a non-positive or unparsable amount', () {
      final notifier = _buildNotifier(now: DateTime(2026, 3, 15));

      expect(
        notifier.addExpense(
            title: 'Coffee', amount: '0', category: ExpenseCategory.food),
        isFalse,
      );
      expect(
        notifier.addExpense(
            title: 'Coffee', amount: '-5', category: ExpenseCategory.food),
        isFalse,
      );
      expect(
        notifier.addExpense(
            title: 'Coffee', amount: 'abc', category: ExpenseCategory.food),
        isFalse,
      );
    });

    test(
        'trims the title, accepts a comma decimal separator, and inserts at the top',
        () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [_expense(id: 'existing', date: DateTime(2026, 3, 1))],
      );

      final added = notifier.addExpense(
        title: '  Coffee  ',
        amount: '4,50',
        category: ExpenseCategory.food,
      );

      expect(added, isTrue);
      final newest = notifier.expenses.first;
      expect(newest.title, 'Coffee');
      expect(newest.amount, 4.5);
      expect(newest.date, DateTime(2026, 3, 15));
    });

    test('notifies listeners when an expense is added', () {
      final notifier = _buildNotifier(now: DateTime(2026, 3, 15));
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.addExpense(
          title: 'Coffee', amount: '4.50', category: ExpenseCategory.food);

      expect(notified, isTrue);
    });
  });

  group('removeExpense', () {
    test('removes only the expense with the matching id', () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [
          _expense(id: '1', date: DateTime(2026, 3, 1)),
          _expense(id: '2', date: DateTime(2026, 3, 2)),
        ],
      );

      notifier.removeExpense('1');

      expect(notifier.expenses.length, 1);
      expect(notifier.expenses.single.id, '2');
    });
  });

  group('monthlySummary', () {
    test('splits totals between the current month and the previous one', () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [
          _expense(id: '1', amount: 10, date: DateTime(2026, 3, 1)),
          _expense(id: '2', amount: 20, date: DateTime(2026, 2, 20)),
        ],
      );

      final summary = notifier.monthlySummary;

      expect(summary.currentMonth, DateTime(2026, 3));
      expect(summary.previousMonth, DateTime(2026, 2));
      expect(summary.currentMonthTotal, 10);
      expect(summary.previousMonthTotal, 20);
    });

    test('rolls back across a year boundary in January', () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 1, 10),
        seed: [_expense(id: '1', amount: 5, date: DateTime(2025, 12, 28))],
      );

      final summary = notifier.monthlySummary;

      expect(summary.previousMonth, DateTime(2025, 12));
      expect(summary.previousMonthTotal, 5);
    });

    test(
        'sorts category totals descending and omits categories with no spending',
        () {
      final notifier = _buildNotifier(
        now: DateTime(2026, 3, 15),
        seed: [
          _expense(
              id: '1',
              amount: 10,
              category: ExpenseCategory.food,
              date: DateTime(2026, 3, 1)),
          _expense(
              id: '2',
              amount: 30,
              category: ExpenseCategory.transport,
              date: DateTime(2026, 3, 2)),
          _expense(
              id: '3',
              amount: 5,
              category: ExpenseCategory.food,
              date: DateTime(2026, 3, 3)),
          _expense(
              id: '4',
              amount: 99,
              category: ExpenseCategory.shopping,
              date: DateTime(2026, 2, 1)),
        ],
      );

      final categoryTotals = notifier.monthlySummary.categoryTotals;

      expect(
        categoryTotals.map((c) => c.category),
        [ExpenseCategory.transport, ExpenseCategory.food],
      );
      expect(categoryTotals.map((c) => c.amount), [30, 15]);
    });
  });
}
