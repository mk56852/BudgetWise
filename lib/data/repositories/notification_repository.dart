import 'package:hive/hive.dart';
import '../models/notification.dart';

class NotificationRepository {
  final Box<AppNotification> _notificationBox =
      Hive.box<AppNotification>('notifications');

  Future<void> addNotification(AppNotification notification) async {
    await _notificationBox.put(notification.id, notification);
  }

  AppNotification? getNotification(String id) {
    return _notificationBox.get(id);
  }

  Future<void> updateNotification(AppNotification notification) async {
    await _notificationBox.put(notification.id, notification);
  }

  Future<void> deleteNotification(String id) async {
    await _notificationBox.delete(id);
  }

  List<AppNotification> getAllNotifications() {
    return _notificationBox.values.toList();
  }
}
