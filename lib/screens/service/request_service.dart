import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/service_request_model.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/providers/service_provider.dart';
<<<<<<< HEAD
import 'package:mechanic_discovery_app/providers/location_provider.dart';
=======
import 'package:mechanic_discovery_app/providers/auth_provider.dart';

import '../../providers/location_provider.dart';
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

class RequestServiceScreen extends StatefulWidget {
  const RequestServiceScreen({Key? key}) : super(key: key);

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
<<<<<<< HEAD
=======
  final TextEditingController _locationController = TextEditingController();
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
<<<<<<< HEAD
=======
    _locationController.dispose();
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final authProvider = context.watch<AuthProvider>();
    if (authProvider.isMechanic) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request Service')),
        body: const Center(child: Text('Mechanics cannot request service')),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Request Service')),
=======
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMechanic = context.watch<AuthProvider>().isMechanic;
    if (isMechanic) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Request Service'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Mechanics cannot request service.',
              style: textTheme.titleLarge?.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Request Service'),
        backgroundColor: colorScheme.background,
        elevation: 1,
      ),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Describe your issue',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Problem Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
<<<<<<< HEAD
                        fillColor: colorScheme.surface,
=======
                        fillColor: colorScheme.background,
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please describe the problem'
                          : null,
                    ),
<<<<<<< HEAD
=======
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                    ),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
                    const SizedBox(height: 28),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: textTheme.labelLarge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.send),
                            label: const Text('Submit Request'),
                            onPressed: _submitRequest,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final location = context.read<LocationProvider>().currentPosition;
      if (location == null) {
        throw Exception('Location not available');
      }

      await context.read<ServiceProvider>().requestService(
        location.latitude,
        location.longitude,
        _descriptionController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service request submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting request: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
