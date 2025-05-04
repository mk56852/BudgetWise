import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/category_amount.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseCharts extends StatefulWidget {
  final List<Transaction> transactions;
  final Widget title;
  const ExpenseCharts(
      {super.key, required this.transactions, required this.title});

  @override
  State<ExpenseCharts> createState() => _ExpenseChartsState();
}

class _ExpenseChartsState extends State<ExpenseCharts> {
  late List<String> shortNames;
  late Map<String, double> items;
  bool isBarChart = false;
  @override
  void initState() {
    shortNames = [
      "F",
      "T",
      "H",
      "S",
      "E",
      "HE",
      "TR",
      "ED",
      "O",
    ];
    items = AppServices.transactionService
        .getTotalExpensesForCategoriesFromList(widget.transactions);
    super.initState();
  }

  void updateState(bool flag) {
    if (flag != isBarChart) {
      setState(() {
        isBarChart = flag;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ExpenseCharts oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      setState(() {
        items = AppServices.transactionService
            .getTotalExpensesForCategoriesFromList(widget.transactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color c1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.blue.withOpacity(0.25)
        : AppColors.darkBlueColor.withOpacity(0.1);

    Color c2 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : AppColors.darkBlueColor.withOpacity(0.9);

    Color c3 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : AppColors.darkBlueColor;
    return Center(
      // Centering the widget
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: widget.title),
              AppIconButton(
                  icon: Icons.bar_chart,
                  onTap: () => updateState(true),
                  text: ""),
              SizedBox(
                width: 5,
              ),
              AppIconButton(
                  icon: Icons.radar, onTap: () => updateState(false), text: "")
            ],
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items.entries
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: CategoryWidget(
                          amount: item.value,
                          name: item.key,
                          icon: AppCategoriesIcon[item.key]!,
                          height: 150,
                          width: 125,
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.3,
            child: items == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 80,
                            color: c2,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No records yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: c2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : isBarChart
                    ? BarChart(
                        BarChartData(
                          barGroups:
                              List.generate(AppCategories.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  color: c3,
                                  toY: items[AppCategories[index]] ?? 0,
                                  // Updated bar color
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
                                      value.toInt() < AppCategories.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        shortNames[
                                            value.toInt()], // Using short names
                                        style: const TextStyle(
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
                              return FlLine(color: c2, strokeWidth: 0.2);
                            },
                          ),
                        ),
                      )
                    : RadarChart(
                        RadarChartData(
                          dataSets: [
                            RadarDataSet(
                              dataEntries:
                                  List.generate(AppCategories.length, (index) {
                                return RadarEntry(
                                  value: items[AppCategories[index]] ?? 0,
                                );
                              }),
                              borderWidth: 1,
                              borderColor: c2,
                              fillColor: c1,
                            ),
                          ],
                          radarTouchData: RadarTouchData(
                            touchCallback: (FlTouchEvent event, response) {
                              if (response != null &&
                                  response.touchedSpot != null) {
                                final entry =
                                    response.touchedSpot!.touchedRadarEntry;
                                final category = AppCategories[response
                                    .touchedSpot!.touchedRadarEntryIndex];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.containerColor2,
                                    title: Text(
                                      category,
                                    ),
                                    content: Text(
                                      '${entry.value.toStringAsFixed(2)} DT',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          radarBackgroundColor: Colors.transparent,
                          radarBorderData: BorderSide(color: c2, width: 2),
                          titlePositionPercentageOffset: 0.2,
                          titleTextStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          getTitle: (index, angle) {
                            return RadarChartTitle(
                              text: shortNames[index],
                              angle: angle,
                            );
                          },
                          tickCount: 4,
                          ticksTextStyle: TextStyle(color: c2, fontSize: 10),
                          tickBorderData: BorderSide(color: c2, width: 0.5),
                          gridBorderData: BorderSide(color: c2, width: 0.5),
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
    Color c2 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.7)
        : Colors.black.withOpacity(0.8);
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
              style: TextStyle(
                  color: c2, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              item["full"]!,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
