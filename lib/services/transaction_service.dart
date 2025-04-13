import 'package:budget_wise/data/models/budget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/models/transaction.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/budget_repository.dart';

class TransactionService {
  final TransactionRepository _transactionRepository;
  final BudgetRepository _budgetRespository;

  TransactionService(this._transactionRepository, this._budgetRespository);
  ValueListenable<Box<Transaction>> get transactionsListenable =>
      _transactionRepository.transactionsListenable;

  /***
   * Add Section 
   */

  Future<void> addTransaction(
      BuildContext context, Transaction transaction) async {
    // Fetch the current budget
    Budget budget = _budgetRespository.getBudget()!;

    // Update the budget amount based on the transaction type
    double newAmount = budget.amount;
    if (transaction.type == 'income') {
      newAmount += transaction.amount;
    } else if (transaction.type == 'expense') {
      newAmount -= transaction.amount;
    }

    // Log the budget change

    if (transaction.date.isAfter(DateTime.now())) {
      // Show confirmation dialog to the user
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Schedule Transaction'),
            content: Text(
                'You chose a later date. Would you like to schedule this transaction or complete it now and mark it as done?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Save and complete'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Save and schedule'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // User confirmed scheduling
        transaction.isAchieved = false;
        _transactionRepository.addTransaction(transaction);
        return;
      } else {
        // User chose to update immediately
        transaction.isAchieved = true;
      }
    }
    budget.updateBudget(newAmount, DateTime.now(), transaction.id);
    await _budgetRespository.updateBudget(budget);
    _transactionRepository.addTransaction(transaction);
  }

  Transaction? getTransactionById(String id) {
    return _transactionRepository.getTransaction(id);
  }
  /***
   * Function For period of time
   */

  List<Transaction> getTransactionForCustomDate(DateTime start, DateTime end) {
    DateTime dayBefore = start.subtract(Duration(days: 1));

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(dayBefore) &&
            transaction.date.isBefore(end))
        .toList();
  }

  List<Transaction> getExpensesForCustomDate(DateTime start, DateTime end) {
    DateTime dayBefore = start.subtract(Duration(days: 1));

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(dayBefore) &&
            transaction.date.isBefore(end) &&
            transaction.type == "expense")
        .toList();
  }

  List<Transaction> getIncomesForCustomDate(DateTime start, DateTime end) {
    DateTime dayBefore = start.subtract(Duration(days: 1));

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(dayBefore) &&
            transaction.date.isBefore(end) &&
            transaction.type == "income")
        .toList();
  }

  double calculateTotalIncomeForCustomDate(DateTime start, DateTime end) {
    List<Transaction> allTransactions = getIncomesForCustomDate(start, end);
    return allTransactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  double calculateTotalExpenseForCustomDate(DateTime start, DateTime end) {
    List<Transaction> allTransactions = getExpensesForCustomDate(start, end);
    return allTransactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  /***
   * Functions By Month
   */

  List<Transaction> getAllTranasactionsForMonth(int year, int month) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime currentDate = DateTime.now();

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            transaction.date.isBefore(currentDate))
        .toList();
  }

  List<Transaction> getExpensesFromMonthYear(int year, int month) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime currentDate = DateTime.now();

    // Fetch all transactions
    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    // Filter for expenses within the date range
    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            transaction.date.isBefore(currentDate.add(Duration(days: 1))) &&
            transaction.type == 'expense')
        .toList();
  }

  List<Transaction> getIncomesFromMonthYear(int year, int month) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime currentDate = DateTime.now();

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions
        .where((transaction) =>
            transaction.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            transaction.date.isBefore(currentDate.add(Duration(days: 1))) &&
            transaction.type == 'income')
        .toList();
  }

  // Get transactions for a specific month and year
  List<Transaction> getTransactionsByMonth(int year, int month) {
    return _transactionRepository.getTransactionsByMonth(year, month);
  }

  // Calculate total income for a specific month
  double calculateTotalIncomeByMonth(int year, int month) {
    final transactions =
        _transactionRepository.getTransactionsByMonth(year, month);
    return transactions
        .where((transaction) => transaction.type == 'income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expenses for a specific month
  double calculateTotalExpensesByMonth(int year, int month) {
    final transactions =
        _transactionRepository.getTransactionsByMonth(year, month);
    return transactions
        .where((transaction) => transaction.type == 'expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate the net balance (income - expenses) for a specific month
  double calculateNetBalanceByMonth(int year, int month) {
    final totalIncome = calculateTotalIncomeByMonth(year, month);
    final totalExpenses = calculateTotalExpensesByMonth(year, month);
    return totalIncome - totalExpenses;
  }

/**
 * Filter Section
 */
  List<Transaction> getAllTransactionsWithFilter(
      {bool? isRecurring, String? achievementStatus}) {
    List<Transaction> transactions =
        _transactionRepository.getAllTransactions();

    // Apply filters if provided
    if (isRecurring != null) {
      transactions = transactions
          .where((transaction) => transaction.isRecurring == isRecurring)
          .toList();
    }

    if (achievementStatus != null) {
      transactions = transactions.where((transaction) {
        if (achievementStatus == 'achieved') {
          return transaction.isAchieved;
        } else if (achievementStatus == 'not achieved yet') {
          return !transaction.isAchieved;
        }
        return true; // For 'both', return all
      }).toList();
    }

    return transactions;
  }

  /***
   * All Data Section 
   */

  List<Transaction> getAllTransactions() {
    return _transactionRepository.getAllTransactions();
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(String categoryId) {
    return _transactionRepository
        .getAllTransactions()
        .where((transaction) => transaction.categoryId == categoryId)
        .toList();
  }

  List<Transaction> getLastTransactions(int x) {
    // Fetch all transactions
    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    // Sort transactions by date (most recent first)
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Return the last x transactions (or all if fewer than x exist)
    return allTransactions.take(x).toList();
  }

  List<Transaction> getAllIncomes() {
    return _transactionRepository.getTransactionsByType("income");
  }

  List<Transaction> getAllExpense() {
    return _transactionRepository.getTransactionsByType("expense");
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionRepository.deleteTransaction(id);
  }

  Map<String, double> getTotalExpensesForCategories(int? year, int? month) {
    List<Transaction> transactions;
    if (year != null) {
      transactions = getTransactionsByMonth(year, month!);
    } else {
      transactions = _transactionRepository.getAllTransactions();
    }
    Map<String, double> categoryExpenses = {};

    // Loop through all transactions
    for (var transaction in transactions) {
      // Check if the transaction is an expense
      if (transaction.type == "expense") {
        // If the category exists, add the amount, otherwise initialize it
        if (categoryExpenses.containsKey(transaction.categoryId)) {
          categoryExpenses[transaction.categoryId!] =
              categoryExpenses[transaction.categoryId!]! + transaction.amount;
        } else {
          categoryExpenses[transaction.categoryId!] = transaction.amount;
        }
      }
    }

    return categoryExpenses;
  }

  Map<String, double> getTotalIncomesForCategories(int? year, int? month) {
    List<Transaction> transactions;
    if (year != null) {
      transactions = getTransactionsByMonth(year, month!);
    } else {
      transactions = _transactionRepository.getAllTransactions();
    }

    Map<String, double> incomeCategory = {};

    // Loop through all transactions
    for (var transaction in transactions) {
      // Check if the transaction is an expense
      if (transaction.type == "income") {
        // If the category exists, add the amount, otherwise initialize it
        if (incomeCategory.containsKey(transaction.categoryId)) {
          incomeCategory[transaction.categoryId!] =
              incomeCategory[transaction.categoryId!]! + transaction.amount;
        } else {
          incomeCategory[transaction.categoryId!] = transaction.amount;
        }
      }
    }

    return incomeCategory;
  }

  List<Transaction> getNotAchievedTransaction() {
    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();
    return allTransactions
        .where((transaction) => !transaction.isAchieved)
        .toList();
  }
}
