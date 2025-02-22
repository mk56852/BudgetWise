import 'package:budget_wise/core/utils/utils.dart';
import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget_history_entry.dart';

class BudgetHisotryRepository {
  final Box<BudgetHistoryEntry> _budgetBox =
      Hive.box<BudgetHistoryEntry>('budget_history');

  ValueListenable<Box<BudgetHistoryEntry>> get budgetBoxListenable =>
      _budgetBox.listenable();

  Future<void> addHistory(BudgetHistoryEntry budgetHist) async {
    await _budgetBox.put(generateId("Hist:"), budgetHist);
  }

  Future<List<BudgetHistoryEntry>> getAll() async {
    return _budgetBox.values.toList();
  }
}
