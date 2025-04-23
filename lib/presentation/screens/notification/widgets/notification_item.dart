import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/data/models/notification_type.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/goals/goals_details.dart';
import 'package:budget_wise/presentation/screens/transactions/transaction_details.dart';
import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class AppNotificationItem extends StatelessWidget {
  final AppNotification notification;
  final Function refresh;
  const AppNotificationItem(
      {super.key, required this.notification, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: AppContainer(
        color: notification.isRead ? null : AppColors.containerColor2,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  notification.isRead = true;
                  AppServices.notificationService
                      .updateNotification(notification);
                  if (notification.type ==
                      NotificationType.TransactionDeadline) {
                    Transaction transaction = AppServices.transactionService
                        .getTransactionById(notification.objectId)!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionDetailsScreen(
                                transaction: transaction)));
                  } else if (notification.type ==
                      NotificationType.SavingGoalDeadline) {
                    SavingsGoal savingsGoal = AppServices.savingsGoalService
                        .getSavingsGoal(notification.objectId)!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalsDetails(
                                  goal: savingsGoal,
                                )));
                  }
                },
                child: Container(
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
                )),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Text(
              notification.message!,
              style: TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                AppServices.notificationService
                    .deleteNotification(notification.id);

                refresh();
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
