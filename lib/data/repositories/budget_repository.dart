import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';

class BudgetRepository {
  final Box<Budget> _budgetBox = Hive.box<Budget>('budgets');

  ValueListenable<Box<Budget>> get budgetBoxListenable =>
      _budgetBox.listenable();

  Future<void> addBudget(Budget budget) async {
    budget.history.add(BudgetHistoryEntry(
        amount: budget.amount, updatedAt: budget.lastUpdated, lastAmount: 0));
    await _budgetBox.put(budget.id, budget);
  }

  Budget? getBudget() {
    if (_budgetBox.isEmpty) return null;
    return _budgetBox.getAt(0);
  }

  Future<void> updateBudget(Budget budget) async {
    budget.lastUpdated = DateTime.now();
    budget.history.add(BudgetHistoryEntry(
        amount: budget.amount,
        updatedAt: budget.lastUpdated,
        lastAmount: budget.lastAmount));
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> updateBudgetWithIds(
      Budget budget, bool isForSaving, String trasactionId) async {
    budget.lastUpdated = DateTime.now();
    budget.history.add(BudgetHistoryEntry(
        amount: budget.amount,
        updatedAt: budget.lastUpdated,
        isForSavings: isForSaving,
        lastAmount: budget.lastAmount,
        transactionId: trasactionId));
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetBox.delete(id);
  }
}
