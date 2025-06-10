import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Owner Dashboard')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/map');},
            child: const Text('View Map'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/update-location'),
            child: const Text('Update Location'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/request-service'),
            child: const Text('Request Service'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/nearby-mechanics'),
            child: const Text('Find Nearby Mechanics'),
          ),
        ],
      ),
    );
  }
}
