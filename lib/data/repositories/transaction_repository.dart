import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final Box<Transaction> _transactionBox =
      Hive.box<Transaction>('transactions');

  ValueListenable<Box<Transaction>> get transactionsListenable =>
      _transactionBox.listenable();

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Transaction? getTransaction(String id) {
    return _transactionBox.get(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  List<Transaction> getAllTransactions() {
    return _transactionBox.values.toList();
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactionBox.values
        .where((transaction) => transaction.type == type)
        .toList();
  }

  List<Transaction> getTransactionsByMonth(int year, int month) {
    return _transactionBox.values.where((transaction) {
      return transaction.date.year == year && transaction.date.month == month;
    }).toList();
  }
}
