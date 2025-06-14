<<<<<<< HEAD
=======
// lib/widgets/shimmer_loading_overlay.dart
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingOverlay extends StatelessWidget {
  const ShimmerLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surface,
        child: Container(color: theme.scaffoldBackgroundColor),
      ),
    );
  }
}
