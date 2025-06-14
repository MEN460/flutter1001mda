// OwnerHomeScreen.dart
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:mechanic_discovery_app/utils/app_routes.dart';
import 'package:mechanic_discovery_app/utils/gradient_cache.dart';
import 'package:provider/provider.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.logout();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0.5,
        title: Text(
          'Car Owner Dashboard',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
<<<<<<< HEAD
            onPressed: () => _handleLogout(context),
=======
            color: colorScheme.primary,
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
<<<<<<< HEAD
            Text(
              'Choose an action below to get started:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
=======
            const SizedBox(height: 20),
            _buildHeader(context),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.map,
                    title: 'Service Map',
                    onTap: () => Navigator.pushNamed(context, '/map'),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.location_on,
                    title: 'Update Location',
                    onTap: () => Navigator.pushNamed(context, '/update-location'),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.car_repair,
                    title: 'Request Service',
                    onTap: () => Navigator.pushNamed(context, '/request-service'),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.person_search,
                    title: 'Find Mechanics',
                    onTap: () => Navigator.pushNamed(context, '/nearby-mechanics'),
                  ),
                ],
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const DashboardCard(
              icon: Icons.car_repair,
              title: 'Request Service',
              description: 'Request a mechanic to assist you with your car.',
              route: AppRoutes.requestService,
            ),
            const SizedBox(height: 20),
            const DashboardCard(
              icon: Icons.location_on,
              title: 'Update Location',
              description:
                  'Set your current location to find nearby mechanics.',
              route: AppRoutes.updateLocation,
            ),
            const SizedBox(height: 20),
            const DashboardCard(
              icon: Icons.people,
              title: 'Nearby Mechanics',
              description: 'Find mechanics near your current location.',
              route: AppRoutes.nearbyMechanics,
            ),
            const SizedBox(height: 20),
            const DashboardCard(
              icon: Icons.person,
              title: 'My Profile',
              description: 'View and manage your profile information.',
              route: '/car-owner-profile',
            ),
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String route;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: GradientCache.dashboardCardGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
=======
  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: const Icon(Icons.person, size: 36, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Car Owner',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
                  ),
                ),
                const Icon(Icons.chevron_right, size: 30),
              ],
            ),
<<<<<<< HEAD
=======
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildRecentActivity(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Engine Check',
              'Yesterday',
              Icons.car_repair,
              context,
            ),
            const Divider(),
            _buildActivityItem(
              'Tire Replacement',
              '2 days ago',
              Icons.build,
              context,
            ),
            const Divider(),
            _buildActivityItem(
              'Oil Change',
              '1 week ago',
              Icons.local_car_wash,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String service,
    String time,
    IconData icon,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colorScheme.primary),
      ),
      title: Text(
        service,
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        time,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.primary),
    );
  }
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
}
