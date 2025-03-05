import 'package:budget_wise/core/constants/Colors.dart';
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
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    size: 28,
                    color: Colors.white,
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
                      color: transaction.isAchieved
                          ? Colors.green.withOpacity(0.35)
                          : Colors.red.withOpacity(0.35),
                    ),
                    child: Icon(
                      transaction.isAchieved
                          ? Icons.check
                          : Icons.calendar_month,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "${isIncome ? "+" : "-"}\$${transaction.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? Colors.white70
                              : Colors
                                  .white54, // Green for income, Red for expense
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
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      _generateBudge(transaction.categoryId!),
                      if (transaction.isRecurring) _generateBudge("Recurring"),
                    ],
                  )
                ],
              ),
            )
            /* Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy')
                        .format(transaction.date), // Formatting date properly
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "${isIncome ? "+" : "-"}\$${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome
                        ? Colors.white70
                        : Colors.white54, // Green for income, Red for expense
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColors.containerColor2,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    transaction.isAchieved ? "Achieved" : "Not Achieved",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white // Green for income, Red for expense
                        ),
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _generateBudge(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: AppColors.containerColor2,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white // Green for income, Red for expense
              ),
        ),
      ),
    );
  }
}
