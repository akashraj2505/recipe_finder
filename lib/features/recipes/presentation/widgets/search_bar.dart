import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe/recipe_bloc.dart';

// Enhanced Search Bar Widget
class RecipeSearchBar extends StatefulWidget {
  const RecipeSearchBar({super.key});

  @override
  State<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {
            _hasText = value.isNotEmpty;
          });
          context.read<RecipeBloc>().add(SearchRecipes(value));
        },
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _hasText = false;
                    });
                    context.read<RecipeBloc>().add(SearchRecipes(''));
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
