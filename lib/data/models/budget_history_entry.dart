import 'package:hive/hive.dart';
part 'budget_history_entry.g.dart';

@HiveType(typeId: 11) // Unique typeId for Hive
class BudgetHistoryEntry {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime updatedAt;

  @HiveField(2)
  String? transactionId; // Link to the transaction that caused the update

  BudgetHistoryEntry({
    required this.amount,
    required this.updatedAt,
    this.transactionId,
  });
}
