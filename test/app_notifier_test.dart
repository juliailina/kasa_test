import 'package:flutter_test/flutter_test.dart';
import 'package:kasa/data/expense_repository.dart';
import 'package:kasa/models/expense.dart';
import 'package:kasa/notifiers/app_notifier.dart';

void main() {
  late AppNotifier notifier;

  setUp(() {
    notifier = AppNotifier(ExpenseRepository());
  });

  group('initial state', () {
    test('loads seed expenses from the repository', () {
      expect(notifier.expenses, isNotEmpty);
    });

    test('starts with no category filter selected', () {
      expect(notifier.selectedCategory, isNull);
      expect(notifier.filteredExpenses.length, notifier.expenses.length);
    });

    test('starts in light mode', () {
      expect(notifier.isDarkMode, isFalse);
    });
  });

  group('filtering', () {
    test('selecting a category only keeps matching expenses', () {
      notifier.selectCategory(ExpenseCategory.food);

      expect(notifier.filteredExpenses, isNotEmpty);
      expect(
        notifier.filteredExpenses.every(
          (e) => e.category == ExpenseCategory.food,
        ),
        isTrue,
      );
    });

    test('selecting null clears the filter', () {
      notifier.selectCategory(ExpenseCategory.bills);
      notifier.selectCategory(null);

      expect(notifier.selectedCategory, isNull);
      expect(notifier.filteredExpenses.length, notifier.expenses.length);
    });

    test('selecting a category notifies listeners', () {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.selectCategory(ExpenseCategory.transport);

      expect(notified, isTrue);
    });
  });

  group('total', () {
    test('sums all expenses when no filter is selected', () {
      final expected = notifier.expenses.fold<double>(
        0,
        (sum, e) => sum + e.amount,
      );

      expect(notifier.total, closeTo(expected, 0.001));
    });

    test('sums only the filtered expenses when a filter is selected', () {
      notifier.selectCategory(ExpenseCategory.food);

      final expected = notifier.expenses
          .where((e) => e.category == ExpenseCategory.food)
          .fold<double>(0, (sum, e) => sum + e.amount);

      expect(notifier.total, closeTo(expected, 0.001));
    });
  });

  group('submitDraft', () {
    test('adds a valid draft to the top of the list', () {
      final countBefore = notifier.expenses.length;

      notifier.updateDraftTitle('Coffee');
      notifier.updateDraftAmount('4.50');
      notifier.updateDraftCategory(ExpenseCategory.food);
      final result = notifier.submitDraft();

      expect(result, isTrue);
      expect(notifier.expenses.length, countBefore + 1);
      expect(notifier.expenses.first.title, 'Coffee');
      expect(notifier.expenses.first.amount, closeTo(4.50, 0.001));
      expect(notifier.expenses.first.category, ExpenseCategory.food);
    });

    test('accepts a comma as the decimal separator', () {
      notifier.updateDraftTitle('Snack');
      notifier.updateDraftAmount('3,25');

      expect(notifier.submitDraft(), isTrue);
      expect(notifier.expenses.first.amount, closeTo(3.25, 0.001));
    });

    test('rejects an empty title', () {
      notifier.updateDraftTitle('   ');
      notifier.updateDraftAmount('10');

      expect(notifier.submitDraft(), isFalse);
    });

    test('rejects an invalid or non-positive amount', () {
      notifier.updateDraftTitle('Something');

      notifier.updateDraftAmount('abc');
      expect(notifier.submitDraft(), isFalse);

      notifier.updateDraftAmount('-5');
      expect(notifier.submitDraft(), isFalse);

      notifier.updateDraftAmount('0');
      expect(notifier.submitDraft(), isFalse);
    });

    test('clears the draft after a successful submit', () {
      notifier.updateDraftTitle('Coffee');
      notifier.updateDraftAmount('4.50');
      notifier.updateDraftCategory(ExpenseCategory.food);
      notifier.submitDraft();

      expect(notifier.draftTitle, isEmpty);
      expect(notifier.draftAmount, isEmpty);
      expect(notifier.draftCategory, ExpenseCategory.other);
    });

    test('notifies listeners when an expense is added', () {
      var notified = false;
      notifier.updateDraftTitle('Coffee');
      notifier.updateDraftAmount('4.50');
      notifier.addListener(() => notified = true);

      notifier.submitDraft();

      expect(notified, isTrue);
    });
  });

  group('theme', () {
    test('toggleDarkMode flips the flag and notifies', () {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.toggleDarkMode();

      expect(notifier.isDarkMode, isTrue);
      expect(notified, isTrue);

      notifier.toggleDarkMode();
      expect(notifier.isDarkMode, isFalse);
    });
  });
}
