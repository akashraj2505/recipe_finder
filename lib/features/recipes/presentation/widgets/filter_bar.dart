import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_finder/features/recipes/presentation/bloc/recipe/recipe_bloc.dart';


class FilterBar extends StatelessWidget {
  final List<String> categories;
  final List<String> areas;

  const FilterBar({
    super.key,
    required this.categories,
    required this.areas,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      buildWhen: (prev, curr) =>
          prev.selectedCategory != curr.selectedCategory ||
          prev.selectedArea != curr.selectedArea,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            _buildFilterSection(
              context: context,
              label: 'Category',
              icon: Icons.restaurant_menu,
              iconColor: Colors.orange,
              items: categories,
              selectedItem: state.selectedCategory,
              onSelect: (category) {
                context.read<RecipeBloc>().add(FilterByCategory(category??""));
              },
            ),
            
            const SizedBox(height: 12),
            
            // Area Filter
            _buildFilterSection(
              context: context,
              label: 'Cuisine',
              icon: Icons.public,
              iconColor: Colors.blue,
              items: areas,
              selectedItem: state.selectedArea,
              onSelect: (area) {
                context.read<RecipeBloc>().add(FilterByArea(area??""));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterSection({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedItem == item;
              
              return Padding(
                padding: EdgeInsets.only(right: index < items.length - 1 ? 8 : 0),
                child: _buildFilterChip(
                  label: item,
                  isSelected: isSelected,
                  color: iconColor,
                  onTap: () {
                    onSelect(isSelected ? null : item);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}