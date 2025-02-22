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
        padding: EdgeInsets.only(top: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.attach_money,
                  size: 28,
                  color: Colors.white), // Single icon for all transactions
            ),
            const SizedBox(width: 12),
            Expanded(
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
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
