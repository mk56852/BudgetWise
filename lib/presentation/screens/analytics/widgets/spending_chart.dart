import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> shortNames = [
      "F",
      "T",
      "H",
      "S",
      "E",
      "HO",
      "TR",
      "ED",
      "O",
    ];

    Map<String, double> items =
        AppServices.transactionService.getTotalExpensesForCategories();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(AppCategories.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: items[AppCategories[index]] ?? 0,
                      color: Colors.white,
                      width: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < AppCategories.length) {
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
    );
  }
}

class CategoryLegend extends StatelessWidget {
  const CategoryLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> legendItems = [
      {"short": "F", "full": "Food & Dining"},
      {"short": "T", "full": "Transport"},
      {"short": "H", "full": "Housing"},
      {"short": "E", "full": "Entertainment"},
      {"short": "S", "full": "Shopping"},
      {"short": "HE", "full": "Health"},
      {"short": "TR", "full": "Travel"},
      {"short": "ED", "full": "Education"},
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
