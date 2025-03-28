import 'package:hive/hive.dart';
part 'notification_type.g.dart';

@HiveType(typeId: 15)
enum NotificationType {
  @HiveField(0)
  SavingGoalDeadline,
  @HiveField(1)
  TransactionDeadline,
  @HiveField(2)
  AnalyticFileGeneration
}
