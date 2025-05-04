import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/budget.dart';
import 'package:budget_wise/services/app_services.dart';
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

  Future<bool> addSimpleTransaction(
      BuildContext context, Transaction transaction) async {
    Budget budget = _budgetRespository.getBudget()!;
    // Update the budget amount based on the transaction type
    double newAmount = budget.amount;
    if (transaction.type == 'income') {
      newAmount += transaction.amount;
    } else if (transaction.type == 'expense') {
      newAmount -= transaction.amount;
    }
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
                child: Text('Confirm Transaction'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Save Transaction and confirm it later'),
              ),
            ],
          );
        },
      );
      if (confirm == null) return false;
      if (confirm == true) {
        // User confirmed scheduling
        transaction.isAchieved = false;
        _transactionRepository.addTransaction(transaction);
        return true;
      } else {
        // User chose to update immediately
        transaction.isAchieved = true;
      }
    }
    budget.update(newAmount);
    await _budgetRespository.updateBudgetWithIds(budget, false, transaction.id);
    _transactionRepository.addTransaction(transaction);
    return true;
  }

  Future<bool> addRecurringTransaction(
      BuildContext context, Transaction transaction) async {
    Budget budget = _budgetRespository.getBudget()!;
    // Update the budget amount based on the transaction type
    double newAmount = budget.amount;
    if (transaction.type == 'income') {
      newAmount += transaction.amount;
    } else if (transaction.type == 'expense') {
      newAmount -= transaction.amount;
    }
    DateTime now = DateTime.now();
    if (transaction.date.month == now.month) {
      bool? confirm = await showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Recurring Transaction"),
            content: Text(
                "Do you want to add this transaction to your budget for this month? (If no you can avhieve it later)"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Achieve it now for current month'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Save and achieve it later'),
              ),
            ],
          );
        },
      );
      if (confirm == null) return false;
      if (!confirm) {
        // User confirmed scheduling
        transaction.isAchieved = false;
        _transactionRepository.addTransaction(transaction);
        return true;
      } else {
        // User chose to update immediately
        transaction.isAchieved = true;
        achieveRecurringForMonth(transaction, getMonthYearKey(now));
      }
      budget.update(newAmount);
      await _budgetRespository.updateBudgetWithIds(
          budget, false, transaction.id);
    } else
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Recurring Transaction"),
            content: Text(
                "You need to manage the recurring transaction manually. Please open the transaction details and validate it for the specific month"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    _transactionRepository.addTransaction(transaction);
    return true;
  }

  Future<bool> addTransaction(
      BuildContext context, Transaction transaction) async {
    if (transaction.isRecurring)
      return addRecurringTransaction(context, transaction);
    else
      return addSimpleTransaction(context, transaction);

    // Log the budget change
  }

  void updateTransaction(Transaction transaction) async {
    await _transactionRepository.updateTransaction(transaction);
  }

  void achieveTransaction(Transaction transaction) {
    transaction.isAchieved = true;
    if (transaction.isRecurring) {
      transaction.monthlyAchievements[getMonthYearKey(DateTime.now())] = true;
    }
    updateTransaction(transaction);
    Budget budget = AppServices.budgetService.getBudget()!;
    budget.lastAmount = budget.amount;
    if (transaction.type == "income") {
      budget.amount += transaction.amount;
    } else {
      budget.amount -= transaction.amount;
    }
    AppServices.budgetService
        .updateBudgetWithIds(budget, false, transaction.id);
  }

  void achieveRecurringForMonth(Transaction transaction, String month) {
    if (!transaction.isRecurring) return;
    transaction.monthlyAchievements[month] = true;
    updateTransaction(transaction);
    Budget budget = AppServices.budgetService.getBudget()!;
    budget.lastAmount = budget.amount;
    if (transaction.type == "income") {
      budget.amount += transaction.amount;
    } else {
      budget.amount -= transaction.amount;
    }
    AppServices.budgetService
        .updateBudgetWithIds(budget, false, transaction.id);
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

  double calculateIncomes(List<Transaction> incomes) {
    return incomes.fold(0.0, (sum, item) => sum + item.amount);
  }

  double calculateExpense(List<Transaction> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  /***
   * Functions By Month
   */

  List<Transaction> getAllTranasactionsForMonth(int year, int month) {
    DateTime startDate = DateTime(year, month, 1);
    int nextMonth = month == 12 ? 1 : month + 1;
    int nextYear = month == 12 ? year + 1 : year;
    DateTime endDate = DateTime(nextYear, nextMonth, 1);

    List<Transaction> allTransactions =
        _transactionRepository.getAllTransactions();

    return allTransactions.where((transaction) {
      if (transaction.date.isAfter(startDate.subtract(Duration(days: 1))) &&
          transaction.date.isBefore(endDate))
        return true;
      else if (transaction.isRecurring &&
          transaction.isTranasctionAchievedForMonth(year, month))
        return true;
      else
        return false;
    }).toList();
  }

  List<Transaction> getExpensesFromMonthYear(int year, int month) {
    List<Transaction> allTransaction = getAllTranasactionsForMonth(year, month);
    return allTransaction.where((item) => item.type == "expense").toList();
  }

  List<Transaction> getIncomesFromMonthYear(int year, int month) {
    List<Transaction> allTransaction = getAllTranasactionsForMonth(year, month);
    return allTransaction.where((item) => item.type == "income").toList();
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
          return transaction.isTranAchieved();
        } else if (achievementStatus == 'not achieved yet') {
          return !transaction.isTranAchieved();
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

  List<Transaction> getRecurringTransaction() {
    return _transactionRepository
        .getAllTransactions()
        .where((transaction) => transaction.isRecurring)
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

  Map<String, double> getTotalExpensesForCategoriesFromList(
      List<Transaction> transactions) {
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
    for (String categ in AppCategories) {
      if (!categoryExpenses.containsKey(categ)) {
        categoryExpenses[categ] = 0.0;
      }
    }
    var sortedEntries = categoryExpenses.entries.toList();

// Step 2: Sort the list in descending order (highest to lowest)
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

// Step 3: Create a new LinkedHashMap to preserve order (optional)
    final sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }

  Map<String, double> getTotalIncomesForCategoriesFromList(
      List<Transaction> transactions) {
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
    for (String categ in incomeSources) {
      if (!incomeCategory.containsKey(categ)) {
        incomeCategory[categ] = 0.0;
      }
    }
    return incomeCategory;
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

  List<Transaction> getNotAchievedTransaction(
      List<Transaction> allTransactions) {
    return allTransactions
        .where((transaction) => !transaction.isTranAchieved())
        .toList();
  }

  List<Transaction> getAchievedTransaction(List<Transaction> allTransactions) {
    return allTransactions
        .where((transaction) => transaction.isTranAchieved())
        .toList();
  }

  List<Transaction> getExpensesTransactionFromList(
      List<Transaction> transacations) {
    return transacations
        .where((transaction) => transaction.type == "expense")
        .toList();
  }

  List<Transaction> getIncomesTransactionFromList(
      List<Transaction> transacations) {
    return transacations
        .where((transaction) => transaction.type == "income")
        .toList();
  }

  double calculateAmountFromList(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  void fixRecurringTransactions() {
    List<Transaction> recurrings = getRecurringTransaction();
    for (Transaction item in recurrings) item.fixRecurringTransaction();
  }
}
