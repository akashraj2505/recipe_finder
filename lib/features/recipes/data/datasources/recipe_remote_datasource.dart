import 'package:recipe_finder/core/constants/api_constants.dart';
import 'package:recipe_finder/core/network/api_client.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';

abstract class RecipeRemoteDatasource {
  Future<List<MealModel>> searchMeals(String query);
  Future<List<MealModel>> filterByCategory(String category);
  Future<List<MealModel>> filterByArea(String area);
  Future<MealModel?> getMealDetail(String id);
  Future<List<String>> getCategories();
  Future<List<String>> getAreas();
}

class RecipeRemoteDatasourceImpl implements RecipeRemoteDatasource {
  final ApiClient apiClient;

  RecipeRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final url =
        ApiConstants.baseUrl + ApiConstants.searchMealByName + query;

    final response = await apiClient.get(url);
    final meals = response['meals'] as List<dynamic>?;

    if (meals == null) return [];

    return meals
        .map((json) => MealModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MealModel>> filterByCategory(String category) async {
    final url =
        ApiConstants.baseUrl + ApiConstants.filterByCategory + category;

    final response = await apiClient.get(url);
    final meals = response['meals'] as List<dynamic>?;

    if (meals == null) return [];

    return meals
        .map((json) => MealModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MealModel>> filterByArea(String area) async {
    final url =
        ApiConstants.baseUrl + ApiConstants.filterByArea + area;

    final response = await apiClient.get(url);
    final meals = response['meals'] as List<dynamic>?;

    if (meals == null) return [];

    return meals
        .map((json) => MealModel.fromJson(json))
        .toList();
  }

  @override
  Future<MealModel?> getMealDetail(String id) async {
    final url =
        ApiConstants.baseUrl + ApiConstants.lookupMealById + id;

    final response = await apiClient.get(url);
    final meals = response['meals'] as List<dynamic>?;

    if (meals == null || meals.isEmpty) return null;

    return MealModel.fromJson(meals.first);
  }

  @override
  Future<List<String>> getCategories() async {
    final url = ApiConstants.baseUrl + ApiConstants.categories;

    final response = await apiClient.get(url);
    final categories = response['categories'] as List<dynamic>;

    return categories
        .map((e) => e['strCategory'] as String)
        .toList();
  }

  @override
  Future<List<String>> getAreas() async {
    final url = ApiConstants.baseUrl + ApiConstants.areas;

    final response = await apiClient.get(url);
    final areas = response['meals'] as List<dynamic>;

    return areas
        .map((e) => e['strArea'] as String)
        .toList();
  }
}
