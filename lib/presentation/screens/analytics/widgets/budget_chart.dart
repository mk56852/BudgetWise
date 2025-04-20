import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetChart extends StatelessWidget {
  final bool forLastMonth;
  const BudgetChart({super.key, this.forLastMonth = false});
  List<FlSpot> _mapBudgetHistoryToSpots(List<BudgetHistoryEntry> history) {
    return history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();
  }

  String _formatDate(int index, List<BudgetHistoryEntry> history) {
    if (index < 0 || index >= history.length) return "";
    return DateFormat('dd').format(history[index].updatedAt);
  }

  @override
  Widget build(BuildContext context) {
    List<BudgetHistoryEntry> budgetHistory;
    DateTime now = DateTime.now();
    if (forLastMonth) {
      budgetHistory = AppServices.budgetService.getBudgetHistoryForLastMonth();
      int previousMonth = now.month == 1 ? 12 : now.month - 1;
      int previousYear = now.month == 1 ? now.year - 1 : now.year;
      BudgetHistoryEntry? first = AppServices.budgetService
          .getFirstBudgetHistoryForMonth(previousMonth, previousYear);
      if (first != null) {
        budgetHistory.add(first);
      }
      if (budgetHistory.isEmpty) {
        budgetHistory = [
          BudgetHistoryEntry(
            updatedAt: DateTime(previousYear, previousMonth, 1), // Default date
            amount: 0.0,
          ),
          BudgetHistoryEntry(
            updatedAt:
                DateTime(previousYear, previousMonth, 28), // Default date
            amount: 0.0,
          ),
        ];
      }
    } else {
      budgetHistory = AppServices.budgetService.getCurrentMonthBudgetHistory();

      BudgetHistoryEntry? first = AppServices.budgetService
          .getFirstBudgetHistoryForMonth(now.month, now.year);
      if (first != null) {
        budgetHistory.add(first);
      }
      if (budgetHistory.length == 1 && first != null) {
        budgetHistory.add(BudgetHistoryEntry(
            amount: first.amount, updatedAt: DateTime.now()));
      }
    }

    budgetHistory =
        AppServices.budgetService.getLatestBudgetHistoryPerDay(budgetHistory);
    // Sort by date
    budgetHistory.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

    return Container(
      height: 250,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      _formatDate(value.toInt(), budgetHistory),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
                reservedSize: 45,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _mapBudgetHistoryToSpots(budgetHistory),
              isCurved: true,
              barWidth: 2,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                  show: false, color: Colors.white.withOpacity(0.04)),
            ),
          ],
        ),
      ),
    );

    /// Maps BudgetHistoryEntry list into FlSpot points
  }
}
