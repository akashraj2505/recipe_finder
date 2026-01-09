part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
  @override
  List<Object?> get props => [];
}

// Fetch initial recipes
class FetchRecipes extends RecipeEvent {}

// Search (debounced)
class SearchRecipes extends RecipeEvent {
  final String query;
  const SearchRecipes(this.query);
  @override
  List<Object?> get props => [query];
}

// Filters - ✅ NOW ACCEPTS NULLABLE VALUES
class FilterByCategory extends RecipeEvent {
  final String? category; // ✅ Changed from String to String?
  const FilterByCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class FilterByArea extends RecipeEvent {
  final String? area; // ✅ Changed from String to String?
  const FilterByArea(this.area);
  @override
  List<Object?> get props => [area];
}

// Clear filters
class ClearFilters extends RecipeEvent {}

// Sorting
class SortByNameAZ extends RecipeEvent {}

class SortByNameZA extends RecipeEvent {}

// View mode toggle
class ToggleViewMode extends RecipeEvent {}

class FetchCategories extends RecipeEvent {}

class FetchAreas extends RecipeEvent {}