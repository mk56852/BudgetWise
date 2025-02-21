import 'package:hive/hive.dart';
part 'money_source.g.dart';

@HiveType(typeId: 2)
class MoneySource {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  final String frequency;

  @HiveField(4)
  DateTime nextDueDate;

  @HiveField(5)
  DateTime lastAdded;

  @HiveField(6)
  final String? notes;

  MoneySource({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextDueDate,
    required this.lastAdded,
    this.notes,
  });
}
