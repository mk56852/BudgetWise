import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../data/models/savings_goal.dart';
import '../data/repositories/savings_goal_repository.dart';

class SavingsGoalService {
  final SavingsGoalRepository _savingsGoalRepository;

  SavingsGoalService(this._savingsGoalRepository);

  ValueListenable<Box<SavingsGoal>> get savingsGoalBoxListenable =>
      _savingsGoalRepository.savingsGoalBoxListenable;
  // Add a new savings goal
  Future<void> addSavingsGoal(SavingsGoal savingsGoal) async {
    await _savingsGoalRepository.addSavingsGoal(savingsGoal);
  }

  // Get a savings goal by ID
  SavingsGoal? getSavingsGoal(String id) {
    return _savingsGoalRepository.getSavingsGoal(id);
  }

  // Update a savings goal
  Future<void> updateSavingsGoal(SavingsGoal savingsGoal) async {
    await _savingsGoalRepository.updateSavingsGoal(savingsGoal);
  }

  // Delete a savings goal
  Future<void> deleteSavingsGoal(String id) async {
    await _savingsGoalRepository.deleteSavingsGoal(id);
  }

  // Get all savings goals
  List<SavingsGoal> getAllSavingsGoals() {
    return _savingsGoalRepository.getAllSavingsGoals();
  }

  double getAllSavedAmount() {
    double totalSavedAmount = 0.0;
    List<SavingsGoal> allSavingsGoals =
        _savingsGoalRepository.getAllSavingsGoals();

    for (var goal in allSavingsGoals) {
      totalSavedAmount += goal.savedAmount;
    }
    return totalSavedAmount;
  }

  List<SavingsGoal> getLastSavingsGoals(int x) {
    // Fetch all transactions
    List<SavingsGoal> allSavingsGoals =
        _savingsGoalRepository.getAllSavingsGoals();

    // Return the last x transactions (or all if fewer than x exist)
    return allSavingsGoals.take(x).toList();
  }
}
