import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';
import 'package:recipe_finder/features/recipes/domain/repositories/recipe_repository.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc
    extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final RecipeRepository repository;

  RecipeDetailBloc(this.repository)
      : super(const RecipeDetailState.loading()) {
    on<FetchRecipeDetail>(_onFetchRecipeDetail);
  }

  Future<void> _onFetchRecipeDetail(
    FetchRecipeDetail event,
    Emitter<RecipeDetailState> emit,
  ) async {
    try {
      final meal = await repository.getMealDetail(event.mealId);
      emit(RecipeDetailState.loaded(meal));
    } catch (e) {
      emit(RecipeDetailState.error(e.toString()));
    }
  }
}
