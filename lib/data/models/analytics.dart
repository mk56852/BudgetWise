import 'package:hive/hive.dart';
part 'analytics.g.dart';

@HiveType(typeId: 7)
class Analytics {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int month;

  @HiveField(2)
  final int year;

  @HiveField(3)
  final double incomeTotal;

  @HiveField(4)
  final double expenseTotal;

  @HiveField(5)
  final String highestExpenseCategory;

  @HiveField(6)
  final double savingsRate;

  Analytics({
    required this.id,
    required this.month,
    required this.year,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.highestExpenseCategory,
    required this.savingsRate,
  });
}
