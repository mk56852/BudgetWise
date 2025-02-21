import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  String? categoryId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final bool isRecurring;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.categoryId,
    required this.date,
    this.description,
    this.isRecurring = false,
  });
}
