import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/home/widgets/recent_transactions.dart';
import 'package:budget_wise/presentation/screens/transactions/add_transaction_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/widgets/transaction_filter_modal.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int selectedIndex = 0;
  late List<Transaction> data;
  late List<Transaction> filteredData;

  Map<String, dynamic>? activeFilters;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    setState(() {
      data = selectedIndex == 0
          ? AppServices.transactionService.getAllExpense()
          : AppServices.transactionService.getAllIncomes();
      filteredData = List.from(data);
      if (activeFilters != null) {
        _applyFilters(activeFilters!);
      }
    });
  }

  void _openFilterModal(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterModal(
        initialAmountFilter: activeFilters?['amountFilter'] ?? 'None',
        initialStartDate: activeFilters?['startDate'],
        initialEndDate: activeFilters?['endDate'],
      ),
    );

    if (result != null) {
      setState(() {
        activeFilters = result;
        _applyFilters(activeFilters!);
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    String amountFilter = filters['amountFilter'];
    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];

    filteredData = List.from(data);

    // Filter by Date Range
    if (startDate != null && endDate != null) {
      filteredData = filteredData.where((transaction) {
        return transaction.date.isAfter(startDate) &&
            transaction.date.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    }

    // Filter by Amount
    if (amountFilter == 'High To Low') {
      filteredData.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (amountFilter == 'Low To High') {
      filteredData.sort((a, b) => a.amount.compareTo(b.amount));
    }
  }

  void _clearFilters() {
    setState(() {
      activeFilters = null;
      filteredData = List.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            "Transactions",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(2, (index) {
            final items = ["Expense Transactions", "Income Transactions"];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  _updateData(); // This will keep the filters
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(
                          refresh: _updateData,
                        ))),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.containerColor2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          if (activeFilters != null)
            InkWell(
              onTap: _clearFilters,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.containerColor2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.filter_alt_off_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          if (activeFilters != null)
            SizedBox(
              width: 10,
            ),
          InkWell(
            onTap: () => _openFilterModal(context),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.containerColor2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ]),
        filteredData.isEmpty
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  filteredData.length,
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
                      child: RecentTransactions(
                        transaction: filteredData[index],
                        refresh: _updateData,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
