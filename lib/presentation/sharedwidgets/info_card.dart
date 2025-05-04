import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String body;
  final IconData icon;

  final bool isPositive;

  const InfoCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.body,
      required this.icon,
      required this.isPositive});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return Container(
      constraints: BoxConstraints(minHeight: 140, minWidth: 160),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2),
      decoration: BoxDecoration(
        color: theme.containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: AppColors.blueColor, shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 22)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color.fromARGB(255, 104, 104, 104),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            size: 14,
          ),
        ],
      ),
    );
  }
}
