import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/service_request_model.dart';


class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback? onAccept;

  const ServiceRequestCard({Key? key, required this.request, this.onAccept})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Status: ${request.status.toUpperCase()}'),
            Text(
              'Location: ${request.latitude.toStringAsFixed(4)}, '
              '${request.longitude.toStringAsFixed(4)}',
            ),
            if (onAccept != null && request.status == 'pending')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept Request'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
