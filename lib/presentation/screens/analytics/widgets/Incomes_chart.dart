import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/category_amount.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomesChart extends StatefulWidget {
  final List<Transaction> transactions;
  final Widget title;
  const IncomesChart(
      {super.key, required this.title, required this.transactions});

  @override
  State<IncomesChart> createState() => _IncomesChartState();
}

class _IncomesChartState extends State<IncomesChart> {
  late List<String> shortNames;
  late Map<String, double> items;
  bool isBarChart = false;
  @override
  void initState() {
    shortNames = [
      "S",
      "F",
      "B",
      "INV",
      "R",
      "I",
      "C",
      "O",
    ];
    items = AppServices.transactionService
        .getTotalIncomesForCategoriesFromList(widget.transactions);
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
  void didUpdateWidget(covariant IncomesChart oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      setState(() {
        items = AppServices.transactionService
            .getTotalIncomesForCategoriesFromList(widget.transactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centering the widget
      child: Column(
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
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items.entries
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: CategoryWidget(
                          amount: item.value,
                          name: item.key,
                          icon: incomeSourcesIcon[item.key]!,
                          height: 150,
                          width: 125,
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 16),
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
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No records yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
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
                              List.generate(incomeSources.length, (index) {
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
                                        shortNames[
                                            value.toInt()], // Using short names
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
                              return FlLine(
                                  color: Colors.white70, strokeWidth: 0.2);
                            },
                          ),
                        ),
                      )
                    : RadarChart(
                        RadarChartData(
                          dataSets: [
                            RadarDataSet(
                              dataEntries:
                                  List.generate(incomeSources.length, (index) {
                                return RadarEntry(
                                  value: items[incomeSources[index]] ?? 0,
                                );
                              }),
                              borderColor: Colors.white,
                              borderWidth: 1,
                              fillColor: Colors.blue.withOpacity(0.25),
                            ),
                          ],
                          radarTouchData: RadarTouchData(
                            touchCallback: (FlTouchEvent event, response) {
                              if (response != null &&
                                  response.touchedSpot != null) {
                                final entry =
                                    response.touchedSpot!.touchedRadarEntry;
                                final category = incomeSources[response
                                    .touchedSpot!.touchedRadarEntryIndex];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.containerColor2,
                                    title: Text(
                                      category,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                        '${entry.value.toStringAsFixed(2)} DT',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                );
                              }
                            },
                          ),
                          radarBackgroundColor: Colors.transparent,
                          radarBorderData:
                              BorderSide(color: Colors.white70, width: 2),
                          titlePositionPercentageOffset: 0.2,
                          titleTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          getTitle: (index, angle) {
                            return RadarChartTitle(
                              text: shortNames[index],
                              angle: angle,
                            );
                          },
                          tickCount: 5,
                          ticksTextStyle: const TextStyle(
                              color: Colors.white70, fontSize: 10),
                          tickBorderData:
                              BorderSide(color: Colors.white70, width: 0.5),
                          gridBorderData:
                              BorderSide(color: Colors.white70, width: 0.5),
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
