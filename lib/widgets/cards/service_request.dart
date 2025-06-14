/*

import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/service_request_model.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onTap;

  const ServiceRequestCard({
    Key? key,
    required this.request,
    this.onAccept,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'pending':
        return colorScheme.secondary;
      case 'accepted':
        return colorScheme.primary;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      request.description,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(context, request.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Location: \nLatitude ${request.latitude.toStringAsFixed(4)},\nLongitude ${request.longitude.toStringAsFixed(4)}',
                style: textTheme.bodyMedium,
              ),
              if (onAccept != null && request.status.toLowerCase() == 'pending')
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept Request'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


*/
