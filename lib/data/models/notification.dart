import 'package:hive/hive.dart';
part 'notification.g.dart';

@HiveType(typeId: 6)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime scheduledTime;

  @HiveField(4)
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.scheduledTime,
    this.isRead = false,
  });
}
