import 'package:hive/hive.dart';
part 'savings_goal.g.dart';

@HiveType(typeId: 5)
class SavingsGoal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  double savedAmount;

  @HiveField(4)
  final int priority;

  @HiveField(5)
  final DateTime? deadline;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final String? icon;

  @HiveField(8)
  bool isAchieved;
  @HiveField(9)
  DateTime createdAt;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.priority,
    required this.createdAt,
    this.deadline,
    this.notes,
    this.icon,
    this.isAchieved = false,
  });

  int getProgressPercentage() {
    if (targetAmount == 0) return 0; // Avoid division by zero
    double progress = (savedAmount / targetAmount) * 100;
    return progress
        .toInt()
        .clamp(0, 100); // Ensure percentage is between 0 and 100
  }

  int getDailySavingsTarget() {
    if (deadline == null) return 0; // If no deadline, return 0
    int totalDays = deadline!.difference(DateTime.now()).inDays;
    if (totalDays <= 0) return 0; // Avoid negative or zero days
    double remainingAmount = targetAmount - savedAmount;
    if (remainingAmount <= 0) return 0; // Goal already achieved
    return (remainingAmount / totalDays).ceil(); // Daily savings needed
  }
}
