import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/budget.dart';
import '../data/repositories/budget_repository.dart';

class BudgetService {
  final BudgetRepository _budgetRepository;

  BudgetService(this._budgetRepository);

  ValueListenable<Box<Budget>> get budgetBoxListenable =>
      _budgetRepository.budgetBoxListenable;
  Future<void> addBudget(Budget budget) async {
    await _budgetRepository.addBudget(budget);
  }

  Budget? getBudget() {
    return _budgetRepository.getBudget();
  }

  Future<void> updateBudget(Budget budget) async {
    await _budgetRepository.updateBudget(budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetRepository.deleteBudget(id);
  }

  List<BudgetHistoryEntry> getAllHistory() {
    Budget budget = getBudget()!;
    return budget.history;
  }

  List<BudgetHistoryEntry> getCurrentMonthBudgetHistory(Budget budget) {
    final now = DateTime.now();
    return budget.history
        .where((entry) =>
            entry.updatedAt.month == now.month &&
            entry.updatedAt.year == now.year)
        .toList();
  }
}
