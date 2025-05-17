import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/notification_type.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:hive/hive.dart';
part 'notification.g.dart';

@HiveType(typeId: 6)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final NotificationType type;

  @HiveField(2)
  String? message;

  @HiveField(3)
  final DateTime? scheduledTime;

  @HiveField(4)
  final String objectId;

  @HiveField(5)
  bool isRead;

  AppNotification.create({
    required this.id,
    required this.type,
    required this.objectId,
    this.scheduledTime,
    this.message,
    this.isRead = false,
  });

  AppNotification({
    required this.id,
    required this.type,
    required this.objectId,
    this.scheduledTime,
    this.isRead = false,
  }) {
    switch (type) {
      case NotificationType.AnalyticFileGeneration:
        {
          DateTime time = DateTime.now();
          message =
              "Analytics File is available for month - ${time.month} - ${time.year}";
          break;
        }
      case NotificationType.TransactionDeadline:
        {
          message = "Transaction ${objectId} is passed its deadline";
          break;
        }
      case NotificationType.SavingGoalDeadline:
        {
          message = "Savings Goal ${objectId} is passed its deadline";
          break;
        }
      default:
        "";
    }
    ;
  }

  AppNotification.fromSavings(SavingsGoal saving)
      : id = generateId("Notif:"),
        type = NotificationType.SavingGoalDeadline,
        isRead = false,
        objectId = saving.id,
        scheduledTime = saving.deadline,
        message = "Savings Goal \"${saving.name}\" is passed its deadline";

  AppNotification.fromTransaction(Transaction tr)
      : id = generateId("Notif:"),
        type = NotificationType.TransactionDeadline,
        isRead = false,
        objectId = tr.id,
        scheduledTime = tr.date,
        message = "Transaction \"${tr.description}\" is passed its deadline";

  @override
  bool operator ==(Object other) {
    if (other is AppNotification) {
      return this.objectId == other.objectId;
    }
    return false;
  }
}
