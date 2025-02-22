import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterModal extends StatefulWidget {
  final String initialAmountFilter;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const FilterModal({
    super.key,
    required this.initialAmountFilter,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String _selectedAmountFilter;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    // Initialize filters with passed-in values or defaults
    _selectedAmountFilter = widget.initialAmountFilter;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Reset end date if it's before the new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
        _validateDateRange();
      });
    }
  }

  void _validateDateRange() {
    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        _dateError = "End date should be after start date.";
      } else {
        _dateError = null;
      }
    } else {
      _dateError = null;
    }
  }

  void _applyFilters() {
    _validateDateRange();
    if (_dateError == null) {
      Navigator.pop(context, {
        'amountFilter': _selectedAmountFilter,
        'startDate': _startDate,
        'endDate': _endDate
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modal Header
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Filter by Amount Section
          Text(
            "Filter by Amount",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              RadioListTile<String>(
                activeColor: Colors.blue,
                title: Text(
                  "None",
                  style: TextStyle(color: Colors.white),
                ),
                value: "None",
                groupValue: _selectedAmountFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedAmountFilter = value!;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: Colors.blue,
                title: Text(
                  "High To Low",
                  style: TextStyle(color: Colors.white),
                ),
                value: "High To Low",
                groupValue: _selectedAmountFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedAmountFilter = value!;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: Colors.blue,
                title: Text(
                  "Low To High",
                  style: TextStyle(color: Colors.white),
                ),
                value: "Low To High",
                groupValue: _selectedAmountFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedAmountFilter = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30),

          // Date Picker Section
          Text(
            "Select Date Range",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _startDate != null
                          ? DateFormat('dd/MM/yyyy').format(_startDate!)
                          : 'Start Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _endDate != null
                          ? DateFormat('dd/MM/yyyy').format(_endDate!)
                          : 'End Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_dateError != null) ...[
            SizedBox(height: 10),
            Text(
              _dateError!,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
          SizedBox(height: 30),

          // Apply Button
          AppActionButton(
            text: "Apply Filters",
            icon: Icons.settings,
            onTab: _applyFilters,
          )
        ],
      ),
    );
  }
}
