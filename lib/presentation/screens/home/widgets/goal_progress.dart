import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/presentation/screens/goals/goals_details.dart';
import 'package:flutter/material.dart';

class GoalProgress extends StatelessWidget {
  final SavingsGoal goal;
  final Function? refresh;
  const GoalProgress({super.key, required this.goal, this.refresh});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    AppTheme theme = appTheme.extension<AppTheme>()!;
    double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
    int progressPercent = (progress * 100).toInt();

    List<String> prio = ["Low", "Medium", "Hight"];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalsDetails(
              goal: goal,
              refresh: refresh,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title, Icon & Priority Label
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Added icon (displayed in a CircleAvatar)
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.1),
                          radius: 18,
                          child: Text(
                            goal.icon ?? "🏦",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            goal.name,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.containerColor2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      prio[goal.priority],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress Bar with Percentage
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 12,
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor:
                              appTheme.brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.black38,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              appTheme.brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.9)
                                  : AppColors.darkBlueColor.withOpacity(0.9)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$progressPercent%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Saved & Target Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved: \$${goal.savedAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Target: \$${goal.targetAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
