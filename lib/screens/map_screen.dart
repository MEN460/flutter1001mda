// lib/screens/map_screen.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

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
import '../widgets/shimmer_loading_overlay.dart'; // Add shimmer import
import '../theme/app_theme.dart';

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

  bool get isMechanic => context.watch<AuthProvider>().isMechanic;
  ThemeData get theme => Theme.of(context);
  AppCustomTheme get customTheme =>
      Theme.of(context).extension<AppCustomTheme>()!;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final locationProvider = context.read<LocationProvider>();
    final position = await locationProvider.getCurrentPosition();

    if (!mounted) return;
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;

      final response = await http.get(
        Uri.parse(
          '${ApiEndpoints.baseUrl}/api/service/nearby-requests?latitude=$lat&longitude=$lng&radius=10',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _nearbyRequests = responseData
              .map((data) => ServiceRequest.fromJson(data))
              .toList();
          _updateMarkers();
        });
      } else {
        throw Exception('Failed to load nearby requests');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: \\${e.toString()}')));
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _updateMarkers() {
    _markers.clear();

    if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: latlng.LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          builder: (ctx) => _buildUserMarker(),
        ),
      );
    }

    if (isMechanic) {
      for (final request in _nearbyRequests) {
        _markers.add(
          Marker(
            point: latlng.LatLng(request.latitude, request.longitude),
            builder: (ctx) => GestureDetector(
              onTap: () => _onMarkerTapped(request),
              child: _buildRequestMarker(),
            ),
          ),
        );
      }
    } else if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: latlng.LatLng(
            _currentPosition!.latitude + 0.01,
            _currentPosition!.longitude + 0.01,
          ),
          builder: (ctx) => _buildDummyMarker(),
        ),
      );
    }
  }

  Widget _buildUserMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [customTheme.markerShadow],
      ),
      child: Icon(
        Icons.location_pin,
        color: isMechanic
            ? customTheme.mechanicColor
            : customTheme.nonMechanicColor,
        size: 30,
      ),
    );
  }

  Widget _buildRequestMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [customTheme.markerShadow],
      ),
      child: const Icon(Icons.location_pin, color: Colors.red, size: 30),
    );
  }

  Widget _buildDummyMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [customTheme.markerShadow],
      ),
      child: const Icon(Icons.person_pin, color: Colors.orange, size: 30),
    );
  }

  void _onMarkerTapped(ServiceRequest request) {
    setState(() {
      _selectedRequest = request;
      _showRequestsList = false;
    });

    _mapController.move(
      latlng.LatLng(request.latitude, request.longitude),
      14.0,
    );
  }

  Future<void> _acceptRequest(int requestId) async {
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;

      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/service/accept-request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'request_id': requestId}),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request accepted successfully!')),
        );

        setState(() {
          _nearbyRequests.removeWhere((req) => req.id == requestId);
          _selectedRequest = null;
          _updateMarkers();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to accept request: \\${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: \\${e.toString()}')));
    }
  }

  void _centerMap() {
    if (_currentPosition != null) {
      _mapController.move(
        latlng.LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        14.0,
      );
    }
  }

  Widget _buildMechanicFAB() {
    return FloatingActionButton(
      heroTag: 'location',
      backgroundColor: theme.colorScheme.primary,
      onPressed: _centerMap,
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }

  Widget _buildOwnerFAB() {
    return FloatingActionButton.extended(
      heroTag: 'request_service',
      backgroundColor: theme.colorScheme.primary,
      icon: const Icon(Icons.car_repair, color: Colors.white),
      label: const Text(
        'Request Service',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.pushNamed(context, '/request-service'),
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            FloatingActionButton(
              heroTag: 'back',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 'refresh',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
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
                        onChanged: (value) {},
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
              onPressed: isMechanic
                  ? () => setState(() => _showRequestsList = !_showRequestsList)
                  : () => Navigator.pushNamed(context, '/nearby-mechanics'),
              child: Icon(
                isMechanic
                    ? (_showRequestsList ? Icons.map : Icons.list)
                    : Icons.list,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    if (!isMechanic) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                ? const Center(child: Text('No nearby requests found'))
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition != null
                  ? latlng.LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : latlng.LatLng(-1.2921, 36.8219),
              zoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          // Shimmer loading overlay
          if (_isLoading) const ShimmerLoadingOverlay(),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildTopControls(),
          ),

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

          // Animated requests list
          AnimatedSwitcher(
            duration: customTheme.animationDuration,
            child: _showRequestsList
                ? Positioned(
                    key: const ValueKey('requests_list'),
                    top: MediaQuery.of(context).padding.top + 80,
                    left: 16,
                    right: 16,
                    bottom: _selectedRequest != null ? 180 : 16,
                    child: _buildRequestsList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: isMechanic ? _buildMechanicFAB() : _buildOwnerFAB(),
    );
  }
}

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
