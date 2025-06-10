import 'package:flutter/material.dart';

class MechanicHomeScreen extends StatelessWidget {
  const MechanicHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic Dashboard')),
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
            onPressed: () => Navigator.pushNamed(context, '/nearby-requests'),
            child: const Text('View Service Requests'),
          ),
        ],
      ),
    );
  }
}
