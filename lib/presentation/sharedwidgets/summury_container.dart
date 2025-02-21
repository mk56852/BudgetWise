import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/presentation/sharedwidgets/chart_logo.dart';
import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  final String title;
  final String body;
  final double? minHeight;
  const SummaryContainer({
    Key? key,
    required this.title,
    required this.body,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: minHeight != null
          ? BoxConstraints(minHeight: minHeight!)
          : BoxConstraints(),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.containerColor2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title & Percentage Change
          ChartLogo(color: Colors.white),

          Text(
            title,
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),

          const SizedBox(height: 3),

          // Amount
          Text(
            body,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // View Details Button
        ],
      ),
    );
  }
}
