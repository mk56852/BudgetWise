import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/presentation/screens/home/widgets/goal_progress.dart';
import 'package:budget_wise/presentation/sharedwidgets/toggle_button.dart';
import 'package:budget_wise/presentation/sharedwidgets/vertical_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavingsGoalListScreen extends StatefulWidget {
  const SavingsGoalListScreen({super.key});

  @override
  _SavingsGoalListScreenState createState() => _SavingsGoalListScreenState();
}

class _SavingsGoalListScreenState extends State<SavingsGoalListScreen> {
  List<SavingsGoal> _allGoals = [];
  List<SavingsGoal> _filteredGoals = [];
  bool _isLoading = false;
  int selectedIndex = 0;
  List<String> priorities = ["All", "High", "Medium", "Low"];

  // Filtering options:
  String _selectedPriorityFilter = "All";
  final bool _showAchievedOnly = false;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Replace this with your actual method to retrieve savings goals.
      List<SavingsGoal> goals =
          AppServices.savingsGoalService.getAllSavingsGoals();
      setState(() {
        _allGoals = goals;
      });
      _applyFilters();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading goals")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<SavingsGoal> filtered = _allGoals;

    // Filter by priority if not "All"
    if (_selectedPriorityFilter != "All") {
      filtered = filtered
          .where(
              (goal) => goal.priority == _priorityInt(_selectedPriorityFilter))
          .toList();
    }

    // Filter by achieved goals if selected.
    if (_showAchievedOnly) {
      filtered = filtered.where((goal) => goal.isAchieved).toList();
    }

    setState(() {
      _filteredGoals = filtered;
    });
  }

  int _priorityInt(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return 2;
      case "medium":
        return 1;
      case "low":
        return 0;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Savings Goal",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 34),

        VerticalToggleButton(
            items: [
              "All Goals",
              "High Priority Goal",
              "Medium Priority Goal",
              "Low Priority Goal"
            ],
            onTap: (index) {
              setState(() {
                _selectedPriorityFilter = priorities[index];
                selectedIndex = index;
              });
              _applyFilters();
            },
            selectedIndex: selectedIndex),
        SizedBox(
          height: 10,
        ),
        // Goals List
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredGoals.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 80,
                              color: appTheme.brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No records yet",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : Column(
                    children: List.generate(
                      _filteredGoals.length,
                      (index) {
                        return Animate(
                            effects: [
                              FadeEffect(duration: 400.ms),
                              SlideEffect(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                                duration: 400.ms,
                                curve: Curves.easeOut,
                              ),
                            ],
                            onPlay: (controller) => controller.forward(),
                            delay: (100 * index).ms,
                            child: GoalProgress(
                              goal: _filteredGoals[index],
                              refresh: _loadGoals,
                            ));
                      },
                    ),
                  ),
      ],
    );
  }
}
