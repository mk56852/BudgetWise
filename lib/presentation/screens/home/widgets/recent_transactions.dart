import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/transactions/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentTransactions extends StatelessWidget {
  final Transaction transaction;
  final Function? refresh;
  const RecentTransactions(
      {super.key, required this.transaction, this.refresh});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    bool isIncome = transaction.type.toLowerCase() == "income";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              transaction: transaction,
              refresh: refresh,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.containerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: 28,
                  ),
                ),
                // Badge positioned at the top right
                Positioned(
                  top: -4,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: transaction.isTranAchieved()
                          ? Colors.green.withOpacity(0.35)
                          : Colors.red.withOpacity(0.35),
                    ),
                    child: Icon(
                      transaction.isTranAchieved()
                          ? Icons.check
                          : Icons.calendar_month,
                      size: 12,
                      color: theme.iconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.id,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.textColor,
                          ),
                        ),
                      ),
                      Text(
                        "${isIncome ? "+" : "-"}\$${transaction.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme
                              .textColor, // Green for income, Red for expense
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat('dd MMM yyyy').format(
                              transaction.date), // Formatting date properly
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.secondTextColor,
                          ),
                        ),
                      ),
                      _generateBudge(transaction.categoryId!, theme),
                      if (transaction.isRecurring)
                        _generateBudge("Recurring", theme),
                    ],
                  ),
                  if (transaction.description != null)
                    Text(
                      transaction.description!,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _generateBudge(String text, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: theme.containerColor,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.textColor // Green for income, Red for expense
              ),
        ),
      ),
    );
  }
}
