import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function? refresh;
  const AddTransactionScreen({super.key, this.refresh});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = false; // Default to Expense
  bool isRecurring = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCategory = "Othor";

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> handleSubmit() async {
    // Validation for amount and description
    if (_amountController.text.isEmpty) {
      _showErrorDialog("Amount cannot be empty.");
      return;
    }
    if (_descriptionController.text.isEmpty) {
      _showErrorDialog("Description cannot be empty.");
      return;
    }
    bool isAchieved = selectedDate.isBefore(DateTime.now());
    Map<String, bool?> histo = {};
    if (isRecurring) {
      histo = generateEmptyMonthlyAchievements();
    }
    Transaction transaction = Transaction(
        id: generateId("Trans:"),
        type: isIncome ? "income" : "expense",
        amount: double.parse(_amountController.text),
        date: selectedDate,
        isRecurring: isRecurring,
        categoryId: selectedCategory,
        isAchieved: isAchieved,
        description: _descriptionController.text,
        monthlyAchievements: histo);
    bool result = await AppServices.transactionService
        .addTransaction(context, transaction);
    if (widget.refresh != null) widget.refresh!();
    if (result) showSuccessDialog("Transaction added successfully.");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    AppTheme theme = appTheme.extension<AppTheme>()!;
    List<String> categ = isIncome ? incomeSources : AppCategories;
    return MainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Add Transaction",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toggleButton("Expense", !isIncome, () {
                setState(() {
                  isIncome = false;
                });
              }, theme, appTheme),
              SizedBox(
                width: 5,
              ),
              _toggleButton("Income", isIncome, () {
                setState(() {
                  isIncome = true;
                });
              }, theme, appTheme),
            ],
          ),

          const SizedBox(height: 15),

          // Amount Input
          _inputField(
              label: "Amount",
              controller: _amountController,
              keyboardType: TextInputType.number,
              theme: appTheme),
          const SizedBox(height: 10),
          // Category Dropdown
          _dropdownField("Category", selectedCategory, categ, (value) {
            setState(() {
              selectedCategory = value!;
            });
          }, appTheme),
          const SizedBox(height: 10),
          // Date Picker + Set to Now Button
          _datePickerField(appTheme),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recurring transaction ?",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Switch(
                value: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value;
                  });
                },
                activeColor:
                    Colors.blueAccent, // Color for active state (Income)
                inactiveThumbColor:
                    Colors.grey, // Color for inactive state (Expense)
              ),
            ],
          ),

          Text(
            "When this option is activated, transaction will be added every month to that date.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          SizedBox(
            height: 10,
          ),
          // Description Field
          _inputField(
              label: "Description",
              controller: _descriptionController,
              height: 120,
              keyboardType: TextInputType.text,
              theme: appTheme),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppActionButton(
                    height: 55,
                    text: "Cancel",
                    icon: Icons.cancel_outlined,
                    onTab: () {
                      Navigator.pop(context);
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: AppActionButton(
                    text: "Save",
                    height: 55,
                    icon: Icons.done,
                    onTab: () {
                      handleSubmit();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Toggle Button Widget
  Widget _toggleButton(String text, bool isSelected, VoidCallback onPressed,
      AppTheme theme, ThemeData appTheme) {
    Color selectedColor = appTheme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.9)
        : AppColors.darkBlueColor.withOpacity(0.9);
    Color unselectedColor = Colors.white.withOpacity(0.2);
    Color textSelectedColor =
        appTheme.brightness == Brightness.dark ? Colors.black : Colors.white;
    Color textunselectedColor = appTheme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.8)
        : Colors.black;
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? selectedColor : unselectedColor,
            foregroundColor:
                isSelected ? textSelectedColor : textunselectedColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _inputField(
      {required String label,
      required TextEditingController controller,
      double? height,
      TextInputType? keyboardType,
      required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: height,
        child: TextField(
          maxLines: null,
          expands: height != null,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  // Dropdown Field Widget
  Widget _dropdownField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: theme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Date Picker Field
  Widget _datePickerField(ThemeData theme) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "Date",
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      child: InkWell(
        onTap: _pickDate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('MMMM dd, yyyy').format(selectedDate),
                style: const TextStyle(fontSize: 16)),
            const Icon(Icons.calendar_month, size: 22),
          ],
        ),
      ),
    );
  }
}
