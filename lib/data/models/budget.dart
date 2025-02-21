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

  Budget({
    required this.id,
    required this.amount,
    required this.lastUpdated,
    List<BudgetHistoryEntry>? history,
  }) : history = history ?? [];

  // Add a new history entry when the budget is updated
  void updateBudget(
      double newAmount, DateTime updatedAt, String transactionId) {
    history.add(BudgetHistoryEntry(
      amount: newAmount,
      updatedAt: updatedAt,
      transactionId: transactionId,
    ));
    amount = newAmount;
    lastUpdated = updatedAt;
  }

  // Optional: Add a copyWith method for easier updates
  Budget copyWith({
    String? id,
    double? amount,
    DateTime? lastUpdated,
    List<BudgetHistoryEntry>? history,
  }) {
    return Budget(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
    );
  }
}
