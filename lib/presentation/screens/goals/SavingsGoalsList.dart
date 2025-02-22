import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/presentation/screens/home/widgets/goal_progress.dart';
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
    // Since your MainScreen already wraps screens in a SingleChildScrollView,
    // we simply return a Column here.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Savings Goal",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Filter by priority:',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
        ),
        // Filtering UI

        Wrap(
          spacing: 8.0,
          children: ["All", "High", "Medium", "Low"].map((priority) {
            bool isSelected = _selectedPriorityFilter == priority;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? Colors.white : AppColors.containerColor,
                foregroundColor: isSelected ? Colors.black : Colors.white,
                side: BorderSide(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _selectedPriorityFilter = priority;
                });
                _applyFilters();
              },
              child: Text(priority),
            );
          }).toList(),
        ),

        // Goals List
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredGoals.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: const Center(
                        child: Text(
                      "No savings goals found.",
                      style: TextStyle(color: Colors.white),
                    )),
                  )
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
