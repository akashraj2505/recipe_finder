part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailEvent extends Equatable {
  const RecipeDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipeDetail extends RecipeDetailEvent {
  final String mealId;

  const FetchRecipeDetail(this.mealId);

  @override
  List<Object> get props => [mealId];
}
