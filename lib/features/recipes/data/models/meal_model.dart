import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 0)
class MealModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String area;

  @HiveField(5)
  final String instructions;

  @HiveField(6)
  final List<String> ingredients;

  @HiveField(7)
  final String? youtubeUrl;

  MealModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
    this.youtubeUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'],
      ingredients: _extractIngredients(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strYoutube': youtubeUrl,
      'ingredients': ingredients,
    };
  }

  static List<String> _extractIngredients(Map<String, dynamic> json) {
    final List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().isNotEmpty &&
          ingredient.toString().trim().isNotEmpty) {
        final value = measure != null && measure.toString().isNotEmpty
            ? '$ingredient - $measure'
            : ingredient.toString();

        ingredients.add(value);
      }
    }

    return ingredients;
  }

  List<String> get ingredientsList => ingredients;

  List<String> get instructionSteps {
    return instructions
        .split(RegExp(r'\r\n|\n'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();
  }
}
