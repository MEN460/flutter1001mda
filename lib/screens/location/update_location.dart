import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';

class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({Key? key}) : super(key: key);

  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Location')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _updateLocation,
                child: const Text('Get Current Location'),
              ),
      ),
    );
  }

  Future<void> _updateLocation() async {
    setState(() => _isLoading = true);
    try {
      final locationProvider = context.read<LocationProvider>();
      await locationProvider.getCurrentLocationAndUpdateBackend();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating location: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
