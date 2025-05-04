import 'package:hive/hive.dart';
part 'analytics.g.dart';

@HiveType(typeId: 7)
class Analytics {
  @HiveField(0)
  final String id;

  @HiveField(1)
  int month;

  @HiveField(2)
  final int year;

  @HiveField(3)
  double incomeTotal;

  @HiveField(4)
  double expenseTotal;

  @HiveField(5)
  double totalBudget;

  @HiveField(6)
  double savedForGoal;

  Analytics({
    required this.id,
    required this.month,
    required this.year,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.totalBudget,
    required this.savedForGoal,
  });
}
