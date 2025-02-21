import 'package:hive/hive.dart';
import '../models/analytics.dart';

class AnalyticsRepository {
  final Box<Analytics> _analyticsBox = Hive.box<Analytics>('analytics');

  Future<void> addAnalytics(Analytics analytics) async {
    await _analyticsBox.put(analytics.id, analytics);
  }

  Analytics? getAnalytics(String id) {
    return _analyticsBox.get(id);
  }

  Future<void> updateAnalytics(Analytics analytics) async {
    await _analyticsBox.put(analytics.id, analytics);
  }

  Future<void> deleteAnalytics(String id) async {
    await _analyticsBox.delete(id);
  }

  List<Analytics> getAllAnalytics() {
    return _analyticsBox.values.toList();
  }
}
