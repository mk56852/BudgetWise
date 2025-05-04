import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class RecurringTransactionTracker extends StatefulWidget {
  final Transaction transaction; // Map of month-year to status
  final Color achievedColor; // Color for ✓
  final Color missedColor; // Color for X
  final Color pendingColor; // Border color for pending

  const RecurringTransactionTracker({
    Key? key,
    required this.transaction,
    this.achievedColor = Colors.green,
    this.missedColor = Colors.red,
    this.pendingColor = Colors.grey,
  }) : super(key: key);

  @override
  _RecurringTransactionTrackerState createState() =>
      _RecurringTransactionTrackerState();
}

class _RecurringTransactionTrackerState
    extends State<RecurringTransactionTracker> {
  late Map<String, bool?> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = Map.from(
        widget.transaction.monthlyAchievements); // Local copy for state changes
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20, // Horizontal space between items
      runSpacing: 10, // Vertical space if multiple lines
      children: _transactions.entries.map((entry) {
        return _buildMonthBox(
          month: entry.key,
          status: entry.value,
        );
      }).toList(),
    );
  }

  Widget _buildMonthBox({required String month, required bool? status}) {
    return GestureDetector(
      onTap: () => _toggleStatus(month),
      child: Column(
        children: [
          Text(
            month.split(' ')[0],
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: widget.pendingColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: _getStatusIcon(status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(bool? status) {
    if (status == true) {
      return Text('✓',
          style: TextStyle(color: widget.achievedColor, fontSize: 20));
    } else if (status == false) {
      return Text('X',
          style: TextStyle(color: widget.missedColor, fontSize: 20));
    } else {
      return const SizedBox(); // Empty box for pending
    }
  }

  void _toggleStatus(String month) async {
    if (_transactions[month] == null) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm for this month'),
            content: Text(
                "Do you want to confirm transaction for the selected month ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
      if (confirm != null && confirm == true) {
        AppServices.transactionService
            .achieveRecurringForMonth(widget.transaction, month);
        setState(() {
          _transactions[month] = true;
        });
      }
    }
  }
}
