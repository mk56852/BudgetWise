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

  List<BudgetHistoryEntry> getCurrentMonthBudgetHistory() {
    Budget budget = getBudget()!;
    final now = DateTime.now();
    return budget.history
        .where((entry) =>
            entry.updatedAt.month == now.month &&
            entry.updatedAt.year == now.year)
        .toList();
  }

  List<BudgetHistoryEntry> getBudgetHistoryForMonth(
      Budget budget, int month, int year) {
    return budget.history
        .where((entry) =>
            entry.updatedAt.month == month && entry.updatedAt.year == year)
        .toList();
  }

  BudgetHistoryEntry? getFirstBudgetHistoryForMonth(int month, int year) {
    if (month == 1) {
      month = 12;
      year = year - 1;
    } else {
      month = month - 1;
    }
    Budget budget = getBudget()!;
    return budget.history
        .where((entry) =>
            entry.updatedAt.month == month && entry.updatedAt.year == year)
        .toList()
        .fold<BudgetHistoryEntry?>(null, (prev, curr) {
      return (prev == null || curr.updatedAt.isAfter(prev.updatedAt))
          ? curr
          : prev;
    });
  }

  List<BudgetHistoryEntry> getLatestBudgetHistoryPerDay(
      List<BudgetHistoryEntry> historyList) {
    Map<String, BudgetHistoryEntry> latestEntries = {};

    for (var entry in historyList) {
      String dateKey =
          "${entry.updatedAt.year}-${entry.updatedAt.month}-${entry.updatedAt.day}";

      if (!latestEntries.containsKey(dateKey) ||
          entry.updatedAt.isAfter(latestEntries[dateKey]!.updatedAt)) {
        latestEntries[dateKey] = entry;
      }
    }

    return latestEntries.values.toList();
  }
}
