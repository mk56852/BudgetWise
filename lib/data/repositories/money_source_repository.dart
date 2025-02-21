import 'package:hive/hive.dart';
import '../models/money_source.dart';

class MoneySourceRepository {
  final Box<MoneySource> _moneySourceBox =
      Hive.box<MoneySource>('money_sources');

  // Add a new money source
  Future<void> addMoneySource(MoneySource moneySource) async {
    await _moneySourceBox.put(moneySource.id, moneySource);
  }

  // Get a money source by ID
  MoneySource? getMoneySource(String id) {
    return _moneySourceBox.get(id);
  }

  // Update a money source
  Future<void> updateMoneySource(MoneySource moneySource) async {
    await _moneySourceBox.put(moneySource.id, moneySource);
  }

  // Delete a money source
  Future<void> deleteMoneySource(String id) async {
    await _moneySourceBox.delete(id);
  }

  // Get all money sources
  List<MoneySource> getAllMoneySources() {
    return _moneySourceBox.values.toList();
  }
}
