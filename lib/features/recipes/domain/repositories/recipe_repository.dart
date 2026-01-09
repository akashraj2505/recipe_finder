import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';

abstract class RecipeRepository {
  Future<List<MealModel>> searchMeals(String query);

  Future<List<MealModel>> filterByCategory(String category);

  Future<List<MealModel>> filterByArea(String area);

  Future<MealModel?> getMealDetail(String id);

  Future<List<String>> getCategories();

  Future<List<String>> getAreas();
}
