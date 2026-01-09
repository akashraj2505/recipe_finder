part of 'recipe_bloc.dart';

enum RecipeViewMode { grid, list }

class RecipeState extends Equatable {
  final bool isLoading;
  final List<MealModel> recipes;
  final List<MealModel> filteredRecipes;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedArea;
  final RecipeViewMode viewMode;
  final String? error;
  final List<String> categories;
  final List<String> areas;

  const RecipeState({
    required this.isLoading,
    required this.recipes,
    required this.filteredRecipes,
    required this.searchQuery,
    required this.viewMode,
    required this.categories,
    required this.areas,
    this.selectedCategory,
    this.selectedArea,
    this.error,
  });

  factory RecipeState.initial() {
    return const RecipeState(
      isLoading: false,
      recipes: [],
      filteredRecipes: [],
      searchQuery: '',
      viewMode: RecipeViewMode.grid,
      categories: [],
      areas: [],
    );
  }

  // ✅ FIXED copyWith with clear flags
  RecipeState copyWith({
    bool? isLoading,
    List<MealModel>? recipes,
    List<MealModel>? filteredRecipes,
    String? searchQuery,
    String? selectedCategory,
    String? selectedArea,
    RecipeViewMode? viewMode,
    List<String>? categories,
    List<String>? areas,
    String? error,
    bool clearCategory = false, // ✅ Added
    bool clearArea = false, // ✅ Added
    bool clearError = false, // ✅ Added
  }) {
    return RecipeState(
      isLoading: isLoading ?? this.isLoading,
      recipes: recipes ?? this.recipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      searchQuery: searchQuery ?? this.searchQuery,
      // ✅ FIXED: Use clear flags to properly set null
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedArea: clearArea 
          ? null 
          : (selectedArea ?? this.selectedArea),
      viewMode: viewMode ?? this.viewMode,
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      error: clearError ? null : error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        recipes,
        filteredRecipes,
        searchQuery,
        selectedCategory,
        selectedArea,
        viewMode,
        categories,
        areas,
        error,
      ];
}