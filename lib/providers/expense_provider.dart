import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracker_provider/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(String title, double amount, DateTime date, String category,
      int priority) {
    _expenses.add(
      Expense(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        date: date,
        category: category,
        priority: priority,
      ),
    );
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.firstWhere((expense) => expense.id == id);
  }
}
