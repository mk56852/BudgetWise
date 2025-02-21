import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSavingsGoalScreen extends StatefulWidget {
  final SavingsGoal? savingsGoal;

  const AddSavingsGoalScreen({super.key, this.savingsGoal});

  @override
  State<AddSavingsGoalScreen> createState() => _AddSavingsGoalScreenState();
}

class _AddSavingsGoalScreenState extends State<AddSavingsGoalScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _priority = "Medium";
  DateTime _selectedDate = DateTime.now();
  String _selectedIcon = "✈️";
  bool _isDeadlineEnabled = true;
  bool _isLoading = false;
  final List<Map<String, String>> icons = [
    {"label": "Travel", "icon": "✈️"},
    {"label": "Home", "icon": "🏠"},
    {"label": "Car", "icon": "🚗"},
    {"label": "Jewelry", "icon": "💍"},
    {"label": "Gadgets", "icon": "📱"},
    {"label": "Education", "icon": "📚"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.savingsGoal != null) {
      _goalNameController.text = widget.savingsGoal!.name;
      _amountController.text = widget.savingsGoal!.targetAmount.toString();
      _notesController.text = widget.savingsGoal!.notes ?? '';
      _priority = priorityString(widget.savingsGoal!.priority);
      _selectedIcon = widget.savingsGoal!.icon!;
      _selectedDate = widget.savingsGoal!.deadline ?? DateTime.now();
      _isDeadlineEnabled = widget.savingsGoal!.deadline != null;
    }
  }

  void _pickDate() async {
    if (!_isDeadlineEnabled)
      return; // Prevent opening date picker if checkbox is unchecked

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> handleSubmit() async {
    if (_isLoading) return; // Prevent duplicate submissions

    // Validate required fields
    if (_goalNameController.text.isEmpty) {
      showError("Goal name is required");
      return;
    }

    if (_amountController.text.isEmpty) {
      showError("Target amount is required");
      return;
    }

    double? targetAmount = double.tryParse(_amountController.text);
    if (targetAmount == null || targetAmount <= 0) {
      showError("Enter a valid target amount greater than zero");
      return;
    }

    if (_priority.isEmpty) {
      showError("Priority is required");
      return;
    }

    setState(() => _isLoading = true); // Show loading indicator

    try {
      if (widget.savingsGoal == null) {
        // Add new savings goal
        await AppServices.savingsGoalService.addSavingsGoal(SavingsGoal(
          id: generateId("goal:"),
          name: _goalNameController.text,
          targetAmount: targetAmount,
          savedAmount: 0,
          priority: priorityInt(_priority),
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
          icon: _selectedIcon,
          createdAt: DateTime.now(),
          deadline: _isDeadlineEnabled ? _selectedDate : null,
        ));
        showSuccessDialog("Your savings goal has been added successfully.");
      } else {
        // Update existing savings goal
        SavingsGoal updatedGoal = SavingsGoal(
          id: widget.savingsGoal!.id,
          name: _goalNameController.text,
          targetAmount: targetAmount,
          savedAmount: widget.savingsGoal!.savedAmount,
          priority: priorityInt(_priority),
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
          icon: _selectedIcon,
          createdAt: widget.savingsGoal!.createdAt,
          deadline: _isDeadlineEnabled ? _selectedDate : null,
        );
        await AppServices.savingsGoalService.updateSavingsGoal(updatedGoal);
        showSuccessDialogAndReturnState(
            "Your savings goal has been updated successfully.", updatedGoal);
      }
    } catch (e) {
      showError("Failed to save savings goal");
    } finally {
      if (mounted) setState(() => _isLoading = false); // Hide loading indicator
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialogAndReturnState(
      String message, SavingsGoal updatedGoal) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                    context, updatedGoal); // Go back to previous screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  int priorityInt(String prio) {
    switch (prio.toLowerCase()) {
      case "high":
        return 2;
      case "medium":
        return 1;
      default:
        return 0;
    }
  }

  String priorityString(int prio) {
    switch (prio) {
      case 2:
        return "High";
      case 1:
        return "Medium";
      default:
        return "Low";
    }
  }

  void _setPriority(String priority) {
    setState(() {
      _priority = priority;
    });
  }

  void _setIcon(String icon) {
    setState(() {
      _selectedIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.savingsGoal == null
                        ? "Set Your Goal"
                        : "Update Your Goal",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                // Goal Name
                _inputField("Goal Name", _goalNameController, null),

                // Target Amount
                _inputField("Target Amount (DT)", _amountController, null,
                    TextInputType.number),

                // Priority Selector
                _prioritySelector(),
                SizedBox(
                  height: 16,
                ),
                const Text("Select a deadline",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                _datePicker(),
                SizedBox(
                  height: 16,
                ),
                // Icon Selection
                _iconSelector(),
                SizedBox(
                  height: 16,
                ),
                // Notes
                _inputField("Notes (Optional)", _notesController, 150),
                SizedBox(
                  height: 16,
                ),
                // Cancel & Save Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _actionButton("Cancel", AppColors.containerColor2,
                          () {
                        Navigator.pop(context);
                      }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child:
                          _actionButton("Save", AppColors.containerColor2, () {
                        // Handle Save Action
                        handleSubmit();
                      }),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Text Input Field
  Widget _inputField(
      String label, TextEditingController controller, double? height,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: height,
        child: TextField(
          maxLines: null,
          expands: height != null,
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: AppColors.containerColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ),
    );
  }

  // Priority Selector
  Widget _prioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _priorityButton("High", Colors.white.withOpacity(0.9)),
          _priorityButton("Medium", Colors.white.withOpacity(0.9)),
          _priorityButton("Low", Colors.white.withOpacity(0.9)),
        ],
      ),
    );
  }

  Widget _priorityButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () => _setPriority(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _priority == label ? color : AppColors.containerColor,
        foregroundColor: _priority == label ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  // Deadline Picker
  Widget _datePicker() {
    return ListTile(
      title: Text(
        _isDeadlineEnabled
            ? DateFormat('MMMM dd, yyyy').format(_selectedDate)
            : "No Deadline", // Show text when disabled
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: Checkbox(
        value: _isDeadlineEnabled,
        onChanged: (val) {
          setState(() {
            _isDeadlineEnabled = val ?? false;
          });
        },
        activeColor: Color(0xFF00E5FF).withOpacity(0.7),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today, color: Colors.white),
        onPressed: _pickDate,
      ),
    );
  }

  // Icon Selection
  Widget _iconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Choose an Icon",
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: icons.map((item) {
              return GestureDetector(
                onTap: () => _setIcon(item["icon"]!),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: _selectedIcon == item["icon"]
                      ? Colors.blue
                      : AppColors.containerColor2,
                  child: Text(
                    item["icon"]!,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Action Buttons
  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
