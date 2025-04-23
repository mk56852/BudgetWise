import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetHistoryItem extends StatelessWidget {
  final BudgetHistoryEntry history;

  const BudgetHistoryItem({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    bool isPositifProg = history.amount > history.lastAmount;
    double prog = isPositifProg
        ? history.amount - history.lastAmount
        : history.lastAmount - history.amount;

    return InkWell(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              transaction: transaction,
              refresh: refresh,
            ),
          ),
        );*/
      },
      child: Padding(
        padding: EdgeInsets.only(top: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPositifProg ? Icons.trending_up : Icons.trending_down,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          history.getMessage(),
                          style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
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
                              history.updatedAt), // Formatting date properly
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Text(
                        "${isPositifProg ? "+" : "-"}${prog.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPositifProg
                              ? Colors.white70
                              : Colors
                                  .white54, // Green for income, Red for expense
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${history.lastAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                      Icon(
                        isPositifProg ? Icons.trending_up : Icons.trending_down,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        "${history.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ],
                  )
                ],
              ),
            )
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
