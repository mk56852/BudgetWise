import '../data/models/analytics.dart';
import '../data/repositories/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsService(this._analyticsRepository);

  // Add new analytics data
  Future<void> addAnalytics(Analytics analytics) async {
    await _analyticsRepository.addAnalytics(analytics);
  }

  // Get analytics data by ID
  Analytics? getAnalytics(String id) {
    return _analyticsRepository.getAnalytics(id);
  }

  // Update analytics data
  Future<void> updateAnalytics(Analytics analytics) async {
    await _analyticsRepository.updateAnalytics(analytics);
  }

  // Delete analytics data
  Future<void> deleteAnalytics(String id) async {
    await _analyticsRepository.deleteAnalytics(id);
  }

  // Get all analytics data
  List<Analytics> getAllAnalytics() {
    return _analyticsRepository.getAllAnalytics();
  }
}
