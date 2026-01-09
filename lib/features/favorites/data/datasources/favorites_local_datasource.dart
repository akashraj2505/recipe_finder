import 'package:hive/hive.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';

class FavoritesLocalDataSource {
  static const String _boxName = 'favorites';

  Box<MealModel> get _box => Hive.box<MealModel>(_boxName);

  /// Check if meal is already favorite
  bool isFavorite(String mealId) {
    return _box.containsKey(mealId);
  }

  /// Get all favorite meals
  List<MealModel> getFavorites() {
    return _box.values.toList();
  }

  /// Add or remove favorite
  void toggleFavorite(MealModel meal) {
    if (isFavorite(meal.id)) {
      _box.delete(meal.id);
    } else {
      _box.put(meal.id, meal);
    }
  }
}
