import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';

class NearbyMechanicsScreen extends StatelessWidget {
  const NearbyMechanicsScreen({Key? key}) : super(key: key);

  Future<List<UserModel>> _getNearbyMechanics(BuildContext context) async {
    final location = context.read<LocationProvider>().currentPosition;
    final token = await context.read<StorageService>().getAccessToken();

    final response = await context.read<ApiService>().get(
      '/mechanics/nearby-mechanics?'
      'latitude=${location?.latitude}&'
      'longitude=${location?.longitude}',
      token: token,
    );

    return (response as List).map((item) => UserModel.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Mechanics')),
      body: FutureBuilder<List<UserModel>>(
        future: _getNearbyMechanics(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final mechanic = snapshot.data![index];
              return ListTile(
                title: Text(mechanic.username),
                subtitle: Text(mechanic.phone ?? 'No phone number'),
                trailing: Text(
                  // ignore: unnecessary_string_interpolations
                  '${mechanic.currentLatitude?.toStringAsFixed(2) ?? '??'}, '
                  '${mechanic.currentLongitude?.toStringAsFixed(2) ?? '??'} ',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
