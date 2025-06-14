import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/widgets/location_picker.dart';

class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({Key? key}) : super(key: key);

  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  double? _selectedLat;
  double? _selectedLng;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
<<<<<<< HEAD
    final locationProvider = context.watch<LocationProvider>();

=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          'Update Location',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Set your current location', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'This helps us show mechanics near you',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                LocationPicker(
                  onLocationSelected: (latLng) {
                    setState(() {
                      _selectedLat = latLng.latitude;
                      _selectedLng = latLng.longitude;
                    });
                  },
                  initialLocation: locationProvider.currentPosition?.let(
                    (p) => latlng.LatLng(p.latitude, p.longitude),
                  ),
                ),

                const SizedBox(height: 24),
                _buildActionButtons(context, locationProvider.isProcessing),
              ],
            ),
          ),
          if (locationProvider.isProcessing)
            const LinearProgressIndicator(minHeight: 2),
        ],
=======
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Update Location',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _isLoading
                ? CircularProgressIndicator(color: colorScheme.primary)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: textTheme.labelLarge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _updateLocation,
                    child: const Text('Get Current Location'),
                  ),
          ),
        ),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isProcessing) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Use Current Location'),
            onPressed: isProcessing ? null : _updateLocation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (_selectedLat != null && _selectedLng != null)
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Confirm'),
              onPressed: isProcessing
                  ? null
                  : () => _updateLocationManually(_selectedLat!, _selectedLng!),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _updateLocation() async {
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
    }
  }

  Future<void> _updateLocationManually(
    double latitude,
    double longitude,
  ) async {
    try {
      final locationProvider = context.read<LocationProvider>();
      await locationProvider.updateLocationManually(latitude, longitude);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating location: $e')));
    }
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
// This extension allows you to use the let function in a more concise way.
// It can be used to transform or operate on an object in a functional style.