import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_finder/core/di/injection.dart';
import 'package:recipe_finder/features/favorites/presentation/pages/favorites_page.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/widgets/active_filter_badge.dart';
import 'package:recipe_finder/features/recipes/presentation/widgets/filter_bar.dart';
import 'package:recipe_finder/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:recipe_finder/features/recipes/presentation/pages/recipe_detail_page.dart';
import 'package:recipe_finder/features/recipes/presentation/widgets/search_bar.dart';
import 'package:recipe_finder/features/recipes/presentation/widgets/shimmer_recipe_card.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeBloc>()
        ..add(FetchRecipes())
        ..add(FetchCategories())
        ..add(FetchAreas()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const Text(
                'Discover Recipes',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              actions: [
                _buildIconButton(
                  icon: Icons.favorite,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    );
                  },
                ),
                BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    return _buildIconButton(
                      icon: state.viewMode == RecipeViewMode.grid
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      onPressed: () {
                        context.read<RecipeBloc>().add(ToggleViewMode());
                      },
                    );
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort, color: Colors.black87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'az') {
                      context.read<RecipeBloc>().add(SortByNameAZ());
                    } else if (value == 'za') {
                      context.read<RecipeBloc>().add(SortByNameZA());
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'az',
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha, size: 20),
                          SizedBox(width: 12),
                          Text('Sort A-Z'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'za',
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha, size: 20),
                          SizedBox(width: 12),
                          Text('Sort Z-A'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: RecipeSearchBar(),
                      ),

                      // Filters Section
                      BlocBuilder<RecipeBloc, RecipeState>(
                        buildWhen: (prev, curr) =>
                            prev.categories != curr.categories ||
                            prev.areas != curr.areas ||
                            prev.selectedCategory != curr.selectedCategory ||
                            prev.selectedArea != curr.selectedArea,
                        builder: (context, state) {
                          final hasFilters =
                              state.selectedCategory != null ||
                              state.selectedArea != null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Filters',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const ActiveFilterBadge(),
                                    const Spacer(),
                                    if (hasFilters)
                                      TextButton.icon(
                                        onPressed: () {
                                          context.read<RecipeBloc>().add(
                                            ClearFilters(),
                                          );
                                        },
                                        icon: const Icon(Icons.clear, size: 18),
                                        label: const Text('Clear'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  16,
                                ),
                                child: FilterBar(
                                  categories: state.categories,
                                  areas: state.areas,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Recipe List
                Expanded(
                  child: BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return _buildLoadingView(state.viewMode);
                      }

                      if (state.error != null) {
                        return _buildErrorView(state.error!);
                      }

                      if (state.filteredRecipes.isEmpty) {
                        return _buildEmptyView();
                      }

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.viewMode == RecipeViewMode.grid
                            ? _buildGridView(context, state)
                            : _buildListView(context, state),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.black87),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView(RecipeViewMode viewMode) {
    return viewMode == RecipeViewMode.grid
        ? GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: 6,
            itemBuilder: (_, __) => const ShimmerRecipeCard(isGrid: true),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.only(bottom: index < 5 ? 16 : 0),
              child: const ShimmerRecipeCard(isGrid: false),
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
              'Oops! Something went wrong',
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

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, RecipeState state) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.filteredRecipes.length,
      itemBuilder: (context, index) {
        final meal = state.filteredRecipes[index];
        return RecipeCard(
          meal: meal,
          isGrid: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(mealId: meal.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, RecipeState state) {
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredRecipes.length,
      itemBuilder: (context, index) {
        final meal = state.filteredRecipes[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < state.filteredRecipes.length - 1 ? 16 : 0,
          ),
          child: RecipeCard(
            meal: meal,
            isGrid: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(mealId: meal.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
