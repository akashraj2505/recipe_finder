part of 'recipe_detail_bloc.dart';

class RecipeDetailState extends Equatable {
  final MealModel? meal;
  final bool isLoading;
  final String? error;

  const RecipeDetailState({
    this.meal,
    required this.isLoading,
    this.error,
  });

  const RecipeDetailState.loading()
      : meal = null,
        isLoading = true,
        error = null;

  const RecipeDetailState.loaded(this.meal)
      : isLoading = false,
        error = null;

  const RecipeDetailState.error(this.error)
      : meal = null,
        isLoading = false;

  @override
  List<Object?> get props => [meal, isLoading, error];
}
