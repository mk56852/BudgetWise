import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
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
    Transaction transaction = Transaction(
        id: generateId("Trans:"),
        type: isIncome ? "income" : "expense",
        amount: double.parse(_amountController.text),
        date: selectedDate,
        isRecurring: isRecurring,
        categoryId: selectedCategory,
        isAchieved: !isRecurring,
        description: _descriptionController.text);
    await AppServices.transactionService.addTransaction(context, transaction);
    if (widget.refresh != null) widget.refresh!();
    showSuccessDialog("Transaction added successfully.");
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
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // Income/Expense Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toggleButton("Expense", !isIncome, () {
                setState(() {
                  isIncome = false;
                });
              }),
              SizedBox(
                width: 5,
              ),
              _toggleButton("Income", isIncome, () {
                setState(() {
                  isIncome = true;
                });
              }),
            ],
          ),

          const SizedBox(height: 15),

          // Amount Input
          _inputField(
            label: "Amount",
            controller: _amountController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          // Category Dropdown
          _dropdownField("Category", selectedCategory, categ, (value) {
            setState(() {
              selectedCategory = value!;
            });
          }),
          const SizedBox(height: 10),
          // Date Picker + Set to Now Button
          _datePickerField(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recurring transaction ?",
                style: TextStyle(color: Colors.grey, fontSize: 16),
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
                    Colors.black, // Color for inactive state (Expense)
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
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton("Cancel", AppColors.containerColor2, () {
                Navigator.pop(context);
              }),
              SizedBox(
                width: 10,
              ),
              _actionButton("Save", AppColors.containerColor2, () {
                handleSubmit();
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Toggle Button Widget
  Widget _toggleButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Colors.white : Colors.white.withOpacity(0.05),
            foregroundColor: isSelected ? Colors.black : Colors.white,
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
      TextInputType? keyboardType}) {
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
            fillColor: Colors.white.withOpacity(0.05),
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
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: Colors.black,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child:
                    Text(category, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Date Picker Field
  Widget _datePickerField() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "Date",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
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
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  // Action Button Widget
  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }
}
