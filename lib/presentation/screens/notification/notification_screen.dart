import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/screens/notification/widgets/notification_item.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<AppNotification> notifications =
      AppServices.notificationService.getAllNotificationsSorted();

  void refresh() {
    setState(() {
      notifications =
          AppServices.notificationService.getAllNotificationsSorted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            height: 80,
            width: 80,
            child: Hero(
              tag: "NotifBull",
              child: Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "Notifications",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Column(
            children: notifications
                .map(
                  (item) =>
                      AppNotificationItem(notification: item, refresh: refresh),
                )
                .toList())
      ],
    ));
  }
}
