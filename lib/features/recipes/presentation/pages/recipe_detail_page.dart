import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_finder/core/di/injection.dart';
import 'package:recipe_finder/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:recipe_finder/features/recipes/data/models/meal_model.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe_detail/recipe_detail_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/pages/image_viewer_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetailPage extends StatelessWidget {
  final String mealId;

  const RecipeDetailPage({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeDetailBloc>()..add(FetchRecipeDetail(mealId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return _buildErrorView(state.error!);
            }

            final meal = state.meal!;

            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, meal),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildHeaderSection(meal),
                      _buildTabSection(meal),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, MealModel meal) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Builder(
          builder: (context) {
            final favorites = sl<FavoritesLocalDataSource>();
            final box = Hive.box<MealModel>('favorites');

            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<MealModel> box, _) {
                final isFavorite = box.containsKey(mealId);

                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                        color: isFavorite ? Colors.red : Colors.black87,
                      ),
                    ),
                    onPressed: () {
                      if (context.read<RecipeDetailBloc>().state.meal != null) {
                        favorites.toggleFavorite(
                          context.read<RecipeDetailBloc>().state.meal!,
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ImageViewerPage(imageUrl: meal.thumbnail, heroTag: meal.id),
              ),
            );
          },
          child: Hero(
            tag: meal.id,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(meal.thumbnail, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(MealModel meal) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.category_outlined,
                label: meal.category,
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.public,
                label: meal.area,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color.darken(20),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(MealModel meal) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                border: Border.all(),
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Ingredients'),
                Tab(text: 'Instructions'),
              ],
            ),
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              children: [
                OverviewTab(meal: meal),
                IngredientsTab(meal: meal),
                InstructionsTab(meal: meal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Failed to load recipe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewTab extends StatefulWidget {
  final MealModel meal;

  const OverviewTab({super.key, required this.meal});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab>
    with AutomaticKeepAliveClientMixin {
  late final YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.meal.youtubeUrl ?? '');
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_youtubeController.initialVideoId.isNotEmpty) ...[
            const Text(
              'Video Tutorial',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          const Text(
            'About this Recipe',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Discover the delicious flavors of ${widget.meal.name}, a traditional ${widget.meal.area} dish from the ${widget.meal.category} category.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientsTab extends StatelessWidget {
  final MealModel meal;

  const IngredientsTab({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final ingredients = meal.ingredientsList;

    if (ingredients.isEmpty) {
      return const Center(child: Text('No ingredients available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            bottom: index < ingredients.length - 1 ? 12 : 0,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  ingredients[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InstructionsTab extends StatelessWidget {
  final MealModel meal;

  const InstructionsTab({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final steps = meal.instructionSteps;

    if (steps.isEmpty) {
      return const Center(child: Text('No instructions available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: index < steps.length - 1 ? 20 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[400]!, Colors.orange[600]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    steps[index],
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green * f).round(),
      (blue * f).round(),
    );
  }
}
