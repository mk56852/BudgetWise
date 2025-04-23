import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:hive/hive.dart';

part 'budget.g.dart'; // Hive-generated file

@HiveType(typeId: 1) // Unique typeId for Hive
class Budget {
  @HiveField(0)
  final String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime lastUpdated;

  @HiveField(3)
  List<BudgetHistoryEntry> history;

  @HiveField(4)
  double lastAmount;

  Budget({
    required this.id,
    required this.amount,
    required this.lastUpdated,
    required this.lastAmount,
    List<BudgetHistoryEntry>? history,
  }) : history = history ?? [];

  void update(double newAmount) {
    lastAmount = amount;
    amount = newAmount;
  }
}
