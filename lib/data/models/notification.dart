import 'package:budget_wise/data/models/notification_type.dart';
import 'package:hive/hive.dart';
part 'notification.g.dart';

@HiveType(typeId: 6)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final NotificationType type;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime? scheduledTime;

  @HiveField(4)
  final String objectId;

  @HiveField(5)
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.objectId,
    this.scheduledTime,
    this.isRead = false,
  });
}
