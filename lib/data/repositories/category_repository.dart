import 'package:hive/hive.dart';
import '../models/category.dart';

class CategoryRepository {
  final Box<Category> _categoryBox = Hive.box<Category>('categories');

  // Add a new category
  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  // Get a category by ID
  Category? getCategory(String id) {
    return _categoryBox.get(id);
  }

  // Update a category
  Future<void> updateCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  // Get all categories
  List<Category> getAllCategories() {
    return _categoryBox.values.toList();
  }

  // Get categories by type (income or expense)
  List<Category> getCategoriesByType(String type) {
    return _categoryBox.values
        .where((category) => category.type == type)
        .toList();
  }
}
