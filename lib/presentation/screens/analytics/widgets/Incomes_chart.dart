import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomesBarChart extends StatelessWidget {
  final bool forPreviousMonth;
  const IncomesBarChart({super.key, this.forPreviousMonth = false});

  @override
  Widget build(BuildContext context) {
    final List<String> shortNames = [
      "S",
      "F",
      "B",
      "INV",
      "R",
      "I",
      "C",
      "O",
    ];
    DateTime today = DateTime.now();
    int month = today.month;
    int year = today.year;
    if (forPreviousMonth) {
      year = month == 1 ? year - 1 : year;
      month = month == 1 ? 12 : month - 1;
    }
    Map<String, double> items = AppServices.transactionService
        .getTotalIncomesForCategories(year, month);

    return Center(
      // Centering the widget
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(incomeSources.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: items[incomeSources[index]] ?? 0,
                        color: Colors.white, // Updated bar color
                        width: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < incomeSources.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              shortNames[value.toInt()], // Using short names
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white70, strokeWidth: 0.2);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CategoryLegend(),
        ],
      ),
    );
  }
}

class CategoryLegend extends StatelessWidget {
  const CategoryLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> legendItems = [
      {"short": "S", "full": "Salary"},
      {"short": "F", "full": "Freelance"},
      {"short": "B", "full": "Business"},
      {"short": "INV", "full": "Investments"},
      {"short": "R", "full": "Rental"},
      {"short": "I", "full": "Interest"},
      {"short": "C", "full": "Commissions"},
      {"short": "O", "full": "Other"},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: legendItems.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item["short"]!,
              style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              item["full"]!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
