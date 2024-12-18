import 'package:flutter/material.dart';

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}

class ExpenseModel extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(String description, double amount) {
    _expenses.add(Expense(description: description, amount: amount));
    notifyListeners();
  }

  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}
