import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  /// Initialize notifications
  Future<void> init() async {
    tz.initializeTimeZones(); // Initialize time zones

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> showInstantNotification(String title, String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_id',
      'Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      title,
      message,
      details,
    );
  }

  /// Schedule a notification at a specific time
  Future<void> scheduleNotification(
      int id, String title, String message, DateTime scheduledTime) async {
    final FlutterLocalNotificationsPlugin _notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Convert DateTime to correct timezone and set to 1 PM
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      DateTime(
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        13, // 1 PM
      ),
      tz.local,
    );

    // 🛑 Check if the scheduled time is in the past

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print(
          "⚠ Cannot schedule notification in the past! Adjusting to 5 seconds later.");
      scheduledDate = tz.TZDateTime.now(tz.local)
          .add(Duration(seconds: 5)); // Set to 5s later
    }

    print("⏰ Scheduling Notification for: ${scheduledDate.toLocal()}");

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_id',
          'Scheduled Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Required for Android 12+
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  void checkAllNotification() {
    List<AppNotification> existingNotif =
        AppServices.notificationService.getAllNotifications();
    checkSavingsGoalDeadlines(existingNotif);
    checkTransactionDeadlines(existingNotif);
  }

  void checkSavingsGoalDeadlines(List<AppNotification> existingNotif) {
    DateTime now = DateTime.now();
    List<SavingsGoal> savings =
        AppServices.savingsGoalService.getAllSavingsGoals();
    for (var saving in savings) {
      if (saving.deadline != null &&
          saving.deadline!.isBefore(now) &&
          !saving.isAchieved) {
        AppNotification notification = AppNotification.fromSavings(saving);
        if (!existingNotif.contains(notification)) {
          // 📣 Create a new notification if it doesn't exist
          AppServices.notificationService.addNotification(notification);
        }
      }
    }
  }

  void checkTransactionDeadlines(List<AppNotification> existingNotif) {
    DateTime now = DateTime.now();
    List<Transaction> transactions =
        AppServices.transactionService.getNotAchievedTransaction();
    for (var transaction in transactions) {
      if (transaction.date.isBefore(now) && !transaction.isAchieved) {
        AppNotification notification =
            AppNotification.fromTransaction(transaction);
        if (!existingNotif.contains(notification)) {
          AppServices.notificationService.addNotification(notification);
        }
      }
    }
  }
}
