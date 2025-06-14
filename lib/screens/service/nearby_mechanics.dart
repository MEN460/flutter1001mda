import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';
import 'package:mechanic_discovery_app/services/api_endpoints.dart';
import 'package:mechanic_discovery_app/widgets/cards/mechanic_card.dart';

class NearbyMechanicsScreen extends StatefulWidget {
  const NearbyMechanicsScreen({Key? key}) : super(key: key);

  @override
  State<NearbyMechanicsScreen> createState() => _NearbyMechanicsScreenState();
}

class _NearbyMechanicsScreenState extends State<NearbyMechanicsScreen> {
  late Future<List<UserModel>> _mechanicsFuture;

  @override
  void initState() {
    super.initState();
    _mechanicsFuture = _getNearbyMechanics();
  }

  Future<List<UserModel>> _getNearbyMechanics() async {
    final locationProvider = context.read<LocationProvider>();
    final storageService = context.read<StorageService>();
    final apiService = context.read<ApiService>();

    final location = locationProvider.currentPosition;
    final token = await storageService.getAccessToken();

    // Check if location is available
    if (location == null) {
      throw Exception('Location unavailable. Please enable location services');
    }

    // Check if token is available
    if (token == null) {
      throw Exception('Token not available');
    }

    try {
      final response = await apiService.get(
        '${ApiEndpoints.nearbyMechanics}?latitude=${location.latitude}&longitude=${location.longitude}',
        token: token,
      );

      return (response as List)
          .map((item) => UserModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load mechanics: $e');
    }
  }

  void _showMechanicProfile(BuildContext context, UserModel mechanic) {
    Navigator.pushNamed(context, '/mechanic-profile', arguments: mechanic);
  }

  void _refreshMechanics() {
    setState(() {
      _mechanicsFuture = _getNearbyMechanics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Mechanics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMechanics,
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _mechanicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Finding nearby mechanics...',
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${snapshot.error}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      onPressed: _refreshMechanics,
                    ),
                  ],
                ),
              ),
            );
          }

          final mechanics = snapshot.data ?? [];

          if (mechanics.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off,
                      color: colorScheme.primary,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No mechanics found nearby',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try refreshing or updating your location.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: mechanics.length,
            itemBuilder: (context, index) => MechanicCard(
              mechanic: mechanics[index],
              onTap: () => _showMechanicProfile(context, mechanics[index]),
            ),
          );
        },
      ),
    );
  }
}
