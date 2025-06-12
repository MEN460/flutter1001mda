import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';

class MechanicProfileScreen extends StatelessWidget {
  final UserModel mechanic;
  const MechanicProfileScreen({Key? key, required this.mechanic})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mechanic.username)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mechanic Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('Name: ${mechanic.username}'),
            Text('Email: ${mechanic.email}'),
            Text('Specialization: ${mechanic.specialization ?? 'N/A'}'),
            Text('Rating: ${mechanic.rating?.toStringAsFixed(1) ?? 'N/A'}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
