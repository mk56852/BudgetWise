import '../data/models/category.dart';
import '../data/repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _categoryRepository;

  CategoryService(this._categoryRepository);

  // Add a new category
  Future<void> addCategory(Category category) async {
    await _categoryRepository.addCategory(category);
  }

  // Get a category by ID
  Category? getCategory(String id) {
    return _categoryRepository.getCategory(id);
  }

  // Update a category
  Future<void> updateCategory(Category category) async {
    await _categoryRepository.updateCategory(category);
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    await _categoryRepository.deleteCategory(id);
  }

  // Get all categories
  List<Category> getAllCategories() {
    return _categoryRepository.getAllCategories();
  }

  // Get categories by type (income or expense)
  List<Category> getCategoriesByType(String type) {
    return _categoryRepository.getCategoriesByType(type);
  }
}
