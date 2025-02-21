import '../data/models/notification.dart';
import '../data/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _notificationRepository;

  NotificationService(this._notificationRepository);

  // Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    await _notificationRepository.addNotification(notification);
  }

  // Get a notification by ID
  AppNotification? getNotification(String id) {
    return _notificationRepository.getNotification(id);
  }

  // Update a notification
  Future<void> updateNotification(AppNotification notification) async {
    await _notificationRepository.updateNotification(notification);
  }

  // Delete a notification
  Future<void> deleteNotification(String id) async {
    await _notificationRepository.deleteNotification(id);
  }

  // Get all notifications
  List<AppNotification> getAllNotifications() {
    return _notificationRepository.getAllNotifications();
  }
}
