import 'category_total.dart';

/// A snapshot comparing this month's spending to last month's, computed
/// from a single point in time so all figures stay consistent with
/// each other.
class MonthlySummary {
  const MonthlySummary({
    required this.currentMonth,
    required this.previousMonth,
    required this.currentMonthTotal,
    required this.previousMonthTotal,
    required this.categoryTotals,
  });

  final DateTime currentMonth;
  final DateTime previousMonth;
  final double currentMonthTotal;
  final double previousMonthTotal;

  /// Per-category totals for [currentMonth], sorted by amount descending.
  /// Categories with no spending this month are omitted.
  final List<CategoryTotal> categoryTotals;
}
