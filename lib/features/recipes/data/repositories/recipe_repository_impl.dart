import 'package:recipe_finder/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';
import 'package:recipe_finder/features/recipes/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDatasource remoteDatasource;

  RecipeRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<MealModel>> searchMeals(String query) {
    return remoteDatasource.searchMeals(query);
  }

  @override
  Future<List<MealModel>> filterByCategory(String category) {
    return remoteDatasource.filterByCategory(category);
  }

  @override
  Future<List<MealModel>> filterByArea(String area) {
    return remoteDatasource.filterByArea(area);
  }

  @override
  Future<MealModel?> getMealDetail(String id) {
    return remoteDatasource.getMealDetail(id);
  }

  @override
  Future<List<String>> getCategories() {
    return remoteDatasource.getCategories();
  }

  @override
  Future<List<String>> getAreas() {
    return remoteDatasource.getAreas();
  }
}
