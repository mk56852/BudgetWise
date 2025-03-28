import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:flutter/material.dart';

class AppNotificationItem extends StatelessWidget {
  final AppNotification notification;
  const AppNotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("hello from notifiaction");
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: AppContainer(
          color: notification.isRead ? null : AppColors.containerColor2,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.isRead
                      ? Icons.notifications_rounded
                      : Icons.notification_important,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Text(
                notification.message,
                style: TextStyle(color: Colors.white, fontSize: 15),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
