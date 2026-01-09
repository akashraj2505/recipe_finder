import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';
import 'package:recipe_finder/features/recipes/domain/repositories/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).asyncExpand(mapper);
  };
}

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc(this.repository) : super(RecipeState.initial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<SearchRecipes>(
      _onSearchRecipes,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByArea>(_onFilterByArea);
    on<ClearFilters>(_onClearFilters);
    on<SortByNameAZ>(_onSortAZ);
    on<SortByNameZA>(_onSortZA);
    on<ToggleViewMode>(_onToggleViewMode);
    on<FetchCategories>(_onFetchCategories);
    on<FetchAreas>(_onFetchAreas);
  }

  Future<void> _onFetchRecipes(
    FetchRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final recipes = await repository.searchMeals('');
      emit(
        state.copyWith(
          isLoading: false,
          recipes: recipes,
          filteredRecipes: recipes,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchRecipes(
    SearchRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    final filtered = _applyFilters(
      recipes: state.recipes,
      category: state.selectedCategory,
      area: state.selectedArea,
      query: event.query,
    );

    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredRecipes: filtered,
      ),
    );
  }

  // ✅ FIXED: Handle null values properly
  void _onFilterByCategory(FilterByCategory event, Emitter<RecipeState> emit) {
    // Check if we should clear the category filter
    if (event.category == null || event.category!.isEmpty) {
      final filtered = _applyFilters(
        recipes: state.recipes,
        category: null, // Clear category filter
        area: state.selectedArea,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          clearCategory: true, // Use clear flag
          filteredRecipes: filtered,
        ),
      );
    } else {
      final filtered = _applyFilters(
        recipes: state.recipes,
        category: event.category,
        area: state.selectedArea,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          selectedCategory: event.category,
          filteredRecipes: filtered,
        ),
      );
    }
  }

  // ✅ FIXED: Handle null values properly
  void _onFilterByArea(FilterByArea event, Emitter<RecipeState> emit) {
    // Check if we should clear the area filter
    if (event.area == null || event.area!.isEmpty) {
      final filtered = _applyFilters(
        recipes: state.recipes,
        category: state.selectedCategory,
        area: null, // Clear area filter
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          clearArea: true, // Use clear flag
          filteredRecipes: filtered,
        ),
      );
    } else {
      final filtered = _applyFilters(
        recipes: state.recipes,
        category: state.selectedCategory,
        area: event.area,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          selectedArea: event.area,
          filteredRecipes: filtered,
        ),
      );
    }
  }

  // ✅ FIXED: Use clear flags
  void _onClearFilters(ClearFilters event, Emitter<RecipeState> emit) {
    emit(
      state.copyWith(
        filteredRecipes: state.recipes,
        clearCategory: true, // Use clear flag
        clearArea: true, // Use clear flag
        searchQuery: '',
      ),
    );
  }

  void _onSortAZ(SortByNameAZ event, Emitter<RecipeState> emit) {
    final sorted = [...state.filteredRecipes]
      ..sort((a, b) => a.name.compareTo(b.name));

    emit(state.copyWith(filteredRecipes: sorted));
  }

  void _onSortZA(SortByNameZA event, Emitter<RecipeState> emit) {
    final sorted = [...state.filteredRecipes]
      ..sort((a, b) => b.name.compareTo(a.name));

    emit(state.copyWith(filteredRecipes: sorted));
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<RecipeState> emit) {
    emit(
      state.copyWith(
        viewMode: state.viewMode == RecipeViewMode.grid
            ? RecipeViewMode.list
            : RecipeViewMode.grid,
      ),
    );
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final categories = await repository.getCategories();
      emit(state.copyWith(categories: categories));
    } catch (_) {}
  }

  Future<void> _onFetchAreas(
    FetchAreas event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final areas = await repository.getAreas();
      emit(state.copyWith(areas: areas));
    } catch (_) {}
  }
}

// ✅ FIXED: Handle null and empty string properly
List<MealModel> _applyFilters({
  required List<MealModel> recipes,
  String? category,
  String? area,
  String? query,
}) {
  return recipes.where((meal) {
    // ✅ Check for both null AND empty string
    final matchesCategory = category == null || 
                           category.isEmpty || 
                           meal.category == category;

    // ✅ Check for both null AND empty string
    final matchesArea = area == null || 
                       area.isEmpty || 
                       meal.area == area;

    final matchesSearch = query == null ||
                         query.isEmpty ||
                         meal.name.toLowerCase().contains(query.toLowerCase());

    return matchesCategory && matchesArea && matchesSearch;
  }).toList();
}