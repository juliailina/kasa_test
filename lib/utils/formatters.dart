const List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> monthShortNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatCurrency(double amount) => '\$${amount.toStringAsFixed(2)}';

String formatMonthYear(DateTime date) =>
    '${monthNames[date.month - 1]} ${date.year}';

String formatShortDate(DateTime date) =>
    '${date.day} ${monthShortNames[date.month - 1]}';
