import 'package:flutter/material.dart';
import 'package:recipe_finder/features/recipes/presentation/pages/modern_splash_page.dart';
import 'package:recipe_finder/features/recipes/presentation/pages/splash_page.dart';
import 'core/di/injection.dart';
import 'features/recipes/presentation/pages/recipe_list_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/recipes/data/models/meal_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MealModelAdapter());

  await Hive.openBox<MealModel>('favorites');

  await setupDI();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPageModern(),
    );
  }
}
