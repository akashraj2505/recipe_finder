import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:recipe_finder/core/network/api_client.dart';
import 'package:recipe_finder/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:recipe_finder/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_finder/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_finder/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe_detail/recipe_detail_bloc.dart';


final sl = GetIt.instance;

Future<void> setupDI() async {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(client: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDatasource>(
    () => RecipeRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(sl()),
  );

  // BLoC
  sl.registerFactory(
    () => RecipeBloc(sl()),
  );
  sl.registerFactory(()=>RecipeDetailBloc(sl()));
}
