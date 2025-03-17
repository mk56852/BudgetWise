import 'package:budget_wise/data/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> incomeList;
  final List<Transaction> expenseList;
  final DateTime now; // Only show data up to this date

  const TransactionChart({
    super.key,
    required this.incomeList,
    required this.expenseList,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    Map<int, double> incomeData = _getDailySums(incomeList, now);
    Map<int, double> expenseData = _getDailySums(expenseList, now);

    List<FlSpot> incomeSpots = _generateFlSpots(incomeData, now);
    List<FlSpot> expenseSpots = _generateFlSpots(expenseData, now);

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() > now.day) return const SizedBox.shrink();
                    return Text(
                      "Day ${value.toInt()}",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white24,
                  strokeWidth: 0.5,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: incomeSpots,
                isCurved: true,
                color: Colors.greenAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: expenseSpots,
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      "${spot.y.toStringAsFixed(2)}",
                      const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList();
                },
              ),
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? response) {},
              handleBuiltInTouches: true,
            ),
          ),
        ),
      ),
    );
  }

  /// Groups transactions by day and sums up amounts **only until `now.day`**
  Map<int, double> _getDailySums(List<Transaction> transactions, DateTime now) {
    Map<int, double> dailySums = {};

    for (var transaction in transactions) {
      int day = transaction.date.day;
      if (day <= now.day) {
        dailySums[day] = (dailySums[day] ?? 0) + transaction.amount;
      }
    }

    // Ensure every day up to `now.day` is present, even if no transactions
    for (int i = 1; i <= now.day; i++) {
      dailySums.putIfAbsent(i, () => 0);
    }

    return dailySums;
  }

  /// Converts Map<int, double> to List<FlSpot> for plotting **only until `now.day`**
  List<FlSpot> _generateFlSpots(Map<int, double> data, DateTime now) {
    return data.entries
        .where((entry) => entry.key >= 1 && entry.key <= now.day)
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }
}
