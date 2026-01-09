import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe/recipe_bloc.dart';


class ActiveFilterBadge extends StatelessWidget {
  const ActiveFilterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      buildWhen: (prev, curr) =>
          prev.selectedCategory != curr.selectedCategory ||
          prev.selectedArea != curr.selectedArea,
      builder: (context, state) {
        int count = 0;
        if (state.selectedCategory != null) count++;
        if (state.selectedArea != null) count++;

        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red[500],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}