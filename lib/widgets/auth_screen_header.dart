import 'package:flutter/material.dart';

<<<<<<< HEAD
class AuthScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthScreenHeader({
    Key? key,
    required this.title,
    required this.subtitle,
=======
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? elevation; // Nullable double

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.elevation = 2.0, // Default non-null value
  }) : assert(
         elevation == null || elevation >= 0,
         'Elevation must be null or non-negative',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*

import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? elevation; // Nullable double

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.elevation, // Optional elevation (null or non-negative)
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 10),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 40),
      ],
    );
  }
}
=======
    return Card(
      elevation: elevation,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

 */
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
