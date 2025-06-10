// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/service_request_model.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../services/api_endpoints.dart';

// lib/screens/map_screen.dart (add above MapScreen class)
class RequestInfoCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onAccept;
  final VoidCallback onClose;

  const RequestInfoCard({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Request #${request.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 10),
          Text(request.description),
          const SizedBox(height: 10),
          Text(
            'Distance: ${request.distance?.toStringAsFixed(1) ?? 'N/A'} km',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAccept,
              child: const Text('Accept Request'),
            ),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  final List<Marker> _markers = [];
  ServiceRequest? _selectedRequest;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _showRequestsList = false;
  List<ServiceRequest> _nearbyRequests = [];
  


  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final position = await locationProvider.getCurrentPosition();

    if (position != null) {
      setState(() {
        _currentPosition = position;
        _mapController.move(
          latlng.LatLng(position.latitude, position.longitude),
          14.0,
        );
      });
      _fetchNearbyRequests(position.latitude, position.longitude);
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNearbyRequests(double lat, double lng) async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      final response = await http.get(
        Uri.parse(
          '${ApiEndpoints.baseUrl}/api/service/nearby-requests?latitude=$lat&longitude=$lng&radius=10',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _nearbyRequests = responseData
              .map((data) => ServiceRequest.fromJson(data))
              .toList();
          _updateMarkers();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load nearby requests');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _updateMarkers() {
    _markers.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          width: 40,
          height: 40,
          point: latlng.LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          builder: (ctx) =>
              const Icon(Icons.location_pin, color: Colors.blue, size: 40),
        ),
      );
    }

    // Add request markers
    for (final request in _nearbyRequests) {
      _markers.add(
        Marker(
          width: 40,
          height: 40,
          point: latlng.LatLng(request.latitude, request.longitude),
          builder: (ctx) => GestureDetector(
            onTap: () => _onMarkerTapped(request),
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        ),
      );
    }
  }

  void _onMarkerTapped(ServiceRequest request) {
    setState(() {
      _selectedRequest = request;
      _showRequestsList = false;
    });

    // Move camera to selected request
    _mapController.move(
      latlng.LatLng(request.latitude, request.longitude),
      14.0,
    );
  }

  Future<void> _acceptRequest(int requestId) async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/service/accept-request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'request_id': requestId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request accepted successfully!')),
        );

        // Remove accepted request from list
        setState(() {
          _nearbyRequests.removeWhere((req) => req.id == requestId);
          _selectedRequest = null;
          _updateMarkers();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to accept request: ${response.body}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition != null
                  ? latlng.LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  :  latlng.LatLng(-1.2921, 36.8219), // Fallback to Nairobi coordinates
              zoom: 14.0,
            ),
            children: [
              // OpenStreetMap Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),

              // Markers Layer
              MarkerLayer(markers: _markers),
            ],
          ),

          // Loading Indicator
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Top App Bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    FloatingActionButton(
                      heroTag: 'refresh',
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () => _getCurrentLocation(),
                      child: const Icon(Icons.refresh, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Search nearby requests...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // Implement search functionality
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      heroTag: 'list',
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() => _showRequestsList = !_showRequestsList);
                      },
                      child: Icon(
                        _showRequestsList ? Icons.map : Icons.list,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Request Details Card
          if (_selectedRequest != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RequestInfoCard(
                request: _selectedRequest!,
                onAccept: () => _acceptRequest(_selectedRequest!.id),
                onClose: () => setState(() => _selectedRequest = null),
              ),
            ),

          // Nearby Requests List
          if (_showRequestsList)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              bottom: _selectedRequest != null ? 180 : 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Requests',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_nearbyRequests.length} found',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _nearbyRequests.isEmpty
                          ? const Center(
                              child: Text('No nearby requests found'),
                            )
                          : ListView.builder(
                              itemCount: _nearbyRequests.length,
                              itemBuilder: (context, index) {
                                final request = _nearbyRequests[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.car_repair,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                    'Request #${request.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    request.description,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    '${request.distance?.toStringAsFixed(1) ?? 'N/A'} km',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  onTap: () => _onMarkerTapped(request),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Location Button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'location',
        backgroundColor: Colors.white,
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(
              latlng.LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              14.0,
            );
          }
        },
        child: const Icon(Icons.my_location, color: Colors.black),
      ),
    );
  }
}
