import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/savings_goal.dart';

class SavingsGoalRepository {
  final Box<SavingsGoal> _savingsGoalBox =
      Hive.box<SavingsGoal>('savings_goals');

  ValueListenable<Box<SavingsGoal>> get savingsGoalBoxListenable =>
      _savingsGoalBox.listenable();

  Future<void> addSavingsGoal(SavingsGoal savingsGoal) async {
    await _savingsGoalBox.put(savingsGoal.id, savingsGoal);
  }

  SavingsGoal? getSavingsGoal(String id) {
    return _savingsGoalBox.get(id);
  }

  Future<void> updateSavingsGoal(SavingsGoal savingsGoal) async {
    await _savingsGoalBox.put(savingsGoal.id, savingsGoal);
  }

  Future<void> deleteSavingsGoal(String id) async {
    await _savingsGoalBox.delete(id);
  }

  List<SavingsGoal> getAllSavingsGoals() {
    return _savingsGoalBox.values.toList();
  }
}
