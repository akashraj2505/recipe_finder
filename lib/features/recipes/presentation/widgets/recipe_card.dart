import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_finder/features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../data/models/meal_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_finder/core/di/injection.dart';

class RecipeCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onTap;
  final bool isGrid;

  RecipeCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.isGrid = true,
  });

  final favorites = sl<FavoritesLocalDataSource>();
  final box = Hive.box<MealModel>('favorites');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: isGrid ? _buildGridLayout() : _buildListLayout(),
      ),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(height: 140),
        Padding(padding: const EdgeInsets.all(8), child: _buildInfo()),
      ],
    );
  }

  Widget _buildListLayout() {
    return Row(
      children: [
        _buildImage(height: 90, width: 120),
        Expanded(
          child: Padding(padding: const EdgeInsets.all(8), child: _buildInfo()),
        ),
      ],
    );
  }

Widget _buildImage({double height = 120, double? width}) {
  return Hero(
    tag: meal.id,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          child: CachedNetworkImage(
            imageUrl: meal.thumbnail,
            height: height,
            width: width ?? double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: Colors.grey.shade300),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image),
          ),
        ),

        // ❤️ FAVORITE ICON (REACTIVE)
        Positioned(
          top: 6,
          right: 6,
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<MealModel> box, _) {
              final isFavorite = box.containsKey(meal.id);

              return GestureDetector(
                onTap: () {
                  favorites.toggleFavorite(meal);
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 18,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '${meal.category} • ${meal.area}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
