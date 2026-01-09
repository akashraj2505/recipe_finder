import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRecipeCard extends StatelessWidget {
  final bool isGrid;

  const ShimmerRecipeCard({
    super.key,
    this.isGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: isGrid ? _buildGridSkeleton() : _buildListSkeleton(),
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(height: 140, radius: const BorderRadius.vertical(top: Radius.circular(16))),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(height: 14, width: double.infinity),
              const SizedBox(height: 6),
              _box(height: 12, width: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListSkeleton() {
    return Row(
      children: [
        _box(
          height: 90,
          width: 120,
          radius: const BorderRadius.horizontal(left: Radius.circular(16)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(height: 14, width: double.infinity),
                const SizedBox(height: 6),
                _box(height: 12, width: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _box({
    double height = 16,
    double width = double.infinity,
    BorderRadius radius = BorderRadius.zero,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
      ),
    );
  }
}
