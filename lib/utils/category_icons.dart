import 'package:flutter/material.dart';

import '../models/expense.dart';

const Map<ExpenseCategory, IconData> categoryIcons = {
  ExpenseCategory.food: Icons.restaurant,
  ExpenseCategory.transport: Icons.directions_bus,
  ExpenseCategory.shopping: Icons.shopping_bag,
  ExpenseCategory.bills: Icons.receipt_long,
  ExpenseCategory.entertainment: Icons.movie,
  ExpenseCategory.other: Icons.category,
};
