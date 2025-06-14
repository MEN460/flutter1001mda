import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:mechanic_discovery_app/models/service_request_model.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/providers/service_provider.dart';
import 'package:mechanic_discovery_app/services/api_endpoints.dart';
import 'package:mechanic_discovery_app/widgets/shimmer_loading_overlay.dart';
import 'package:mechanic_discovery_app/theme/app_theme.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:cached_network_image/cached_network_image.dart';

<<<<<<< HEAD
=======
import '../models/service_request_model.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../services/api_endpoints.dart';
import '../widgets/shimmer_loading_overlay.dart'; // Add shimmer import
import '../theme/app_theme.dart';

>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

<<<<<<< HEAD
class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<UserModel> _nearbyMechanics = [];
  bool _showMechanics = false;
=======
class _MapScreenState extends State<MapScreen> {
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  late MapController _mapController;
  final List<Marker> _markers = [];
  ServiceRequest? _selectedRequest;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _showRequestsList = false;
  List<ServiceRequest> _nearbyRequests = [];
<<<<<<< HEAD
  late AnimationController _listAnimationController;
  late Animation<double> _listOpacityAnimation;
  late Animation<Offset> _listSlideAnimation;
  final PopupController _popupController = PopupController();
=======

  bool get isMechanic => context.watch<AuthProvider>().isMechanic;
  ThemeData get theme => Theme.of(context);
  AppCustomTheme get customTheme =>
      Theme.of(context).extension<AppCustomTheme>()!;
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
<<<<<<< HEAD
    _loadInitialData();

    // Initialize animations with default duration
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupAnimations();
  }

  void _setupAnimations() {
    final customTheme = Theme.of(context).extension<AppCustomTheme>();
    if (customTheme == null) return;

    // Update duration if custom theme is available
    _listAnimationController.duration = customTheme.animationDuration;

    _listOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _listSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _listAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (!context.read<AuthProvider>().isMechanic) {
      await _fetchNearbyMechanics();
    }
  }

  Future<void> _fetchNearbyMechanics() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final location = _currentPosition;
      if (location == null) return;

      final response = await context.read<ServiceProvider>().getNearbyMechanics(
        location.latitude,
        location.longitude,
      );

      setState(() => _nearbyMechanics = response);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading mechanics: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
      final serviceProvider = context.read<ServiceProvider>();
      _nearbyRequests = await serviceProvider.getNearbyRequests();
      _updateMarkers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
=======
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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _updateMarkers() {
<<<<<<< HEAD
    if (!mounted) return;

    _markers.clear();

    // Current user marker
=======
    _markers.clear();

>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: latlng.LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
<<<<<<< HEAD
          width: 40,
          height: 40,
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
          builder: (ctx) => _buildUserMarker(),
        ),
      );
    }

<<<<<<< HEAD
    // Mechanic view: service requests
    if (context.read<AuthProvider>().isMechanic) {
=======
    if (isMechanic) {
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
      for (final request in _nearbyRequests) {
        _markers.add(
          Marker(
            point: latlng.LatLng(request.latitude, request.longitude),
<<<<<<< HEAD
            width: 40,
            height: 40,
            builder: (ctx) => GestureDetector(
              onTap: () => _onMarkerTapped(request),
              child: _buildRequestMarker(request),
=======
            builder: (ctx) => GestureDetector(
              onTap: () => _onMarkerTapped(request),
              child: _buildRequestMarker(),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
            ),
          ),
        );
      }
<<<<<<< HEAD
    }
    // Car owner view: mechanics
    else if (_showMechanics) {
      for (final mechanic in _nearbyMechanics) {
        if (mechanic.currentLatitude == null ||
            mechanic.currentLongitude == null)
          continue;

        _markers.add(
          Marker(
            point: latlng.LatLng(
              mechanic.currentLatitude!,
              mechanic.currentLongitude!,
            ),
            width: 50,
            height: 50,
            builder: (ctx) => GestureDetector(
              onTap: () => _onMechanicTapped(mechanic),
              child: _buildMechanicMarker(mechanic),
            ),
          ),
        );
      }
=======
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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    }
  }

  Widget _buildUserMarker() {
<<<<<<< HEAD
    final theme = Theme.of(context);
    final customTheme = theme.extension<AppCustomTheme>();
    final isMechanic = context.read<AuthProvider>().isMechanic;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isMechanic
              ? customTheme?.mechanicColor ?? Colors.blue
              : customTheme?.nonMechanicColor ?? Colors.green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          customTheme?.markerShadow ??
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
        ],
      ),
      child: Icon(
        isMechanic ? Icons.directions_car : Icons.person_pin,
        color: isMechanic
            ? customTheme?.mechanicColor ?? Colors.blue
            : customTheme?.nonMechanicColor ?? Colors.green,
=======
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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
        size: 30,
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildRequestMarker(ServiceRequest request) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<AppCustomTheme>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              customTheme?.markerShadow ??
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
            ],
          ),
          child: Icon(
            Icons.location_pin,
            color: _getStatusColor(request.status),
            size: 40,
          ),
        ),
        if (request.distance != null)
          Positioned(
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  customTheme?.markerShadow ??
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                ],
              ),
              child: Text(
                '${request.distance!.toStringAsFixed(1)}km',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMechanicMarker(UserModel mechanic) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<AppCustomTheme>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              customTheme?.markerShadow ??
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: mechanic.avatarUrl != null
                ? CachedNetworkImageProvider(mechanic.avatarUrl!)
                : null,
            child: mechanic.avatarUrl == null
                ? const Icon(Icons.person, size: 20)
                : null,
          ),
        ),
        if (mechanic.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _onMechanicTapped(UserModel mechanic) {
    Navigator.pushNamed(context, '/mechanic-profile', arguments: mechanic);
  }

  void _toggleRequestsList() {
    setState(() {
      _showRequestsList = !_showRequestsList;
      if (_showRequestsList) {
        _listAnimationController.forward();
      } else {
        _listAnimationController.reverse();
      }
    });
  }

  void _onMarkerTapped(ServiceRequest request) {
    setState(() {
      _selectedRequest = request;
      if (_showRequestsList) {
        _showRequestsList = false;
        _listAnimationController.reverse();
      }
=======
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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    });

    _mapController.move(
      latlng.LatLng(request.latitude, request.longitude),
      14.0,
    );
  }

  Future<void> _acceptRequest(int requestId) async {
    setState(() => _isLoading = true);
<<<<<<< HEAD
    try {
      await context.read<ServiceProvider>().acceptRequest(requestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted successfully!')),
      );
      setState(() {
        _nearbyRequests.removeWhere((req) => req.id == requestId);
        _selectedRequest = null;
        _updateMarkers();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
=======

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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
    final theme = Theme.of(context);
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    return FloatingActionButton(
      heroTag: 'location',
      backgroundColor: theme.colorScheme.primary,
      onPressed: _centerMap,
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }

  Widget _buildOwnerFAB() {
<<<<<<< HEAD
    final theme = Theme.of(context);
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
    final theme = Theme.of(context);
    final isMechanic = context.read<AuthProvider>().isMechanic;

=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
                      color: Colors.black.withAlpha((0.2 * 255).toInt()),
=======
                      color: Colors.black.withOpacity(0.1),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
            if (isMechanic) ...[
              FloatingActionButton(
                heroTag: 'list',
                mini: true,
                backgroundColor: _showRequestsList
                    ? theme.colorScheme.primary
                    : Colors.white,
                onPressed: _toggleRequestsList,
                child: Icon(
                  Icons.list,
                  color: _showRequestsList ? Colors.white : Colors.black,
                ),
              ),
            ] else ...[
              FloatingActionButton(
                heroTag: 'mechanics_toggle',
                mini: true,
                backgroundColor: _showMechanics
                    ? theme.colorScheme.primary
                    : Colors.white,
                onPressed: () {
                  setState(() {
                    _showMechanics = !_showMechanics;
                    _updateMarkers();
                  });
                },
                child: Icon(
                  Icons.garage,
                  color: _showMechanics ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: 'mechanics_list',
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () =>
                    Navigator.pushNamed(context, '/nearby-mechanics'),
                child: const Icon(Icons.list, color: Colors.black),
              ),
            ],
=======
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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
<<<<<<< HEAD
    if (!context.read<AuthProvider>().isMechanic)
      return const SizedBox.shrink();
=======
    if (!isMechanic) return const SizedBox.shrink();
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
<<<<<<< HEAD
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
=======
            color: Colors.black.withOpacity(0.2),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _toggleRequestsList,
=======
                Text(
                  '${_nearbyRequests.length} found',
                  style: const TextStyle(color: Colors.grey),
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
                        leading: Icon(
                          Icons.car_repair,
                          color: _getStatusColor(request.status),
=======
                        leading: const Icon(
                          Icons.car_repair,
                          color: Colors.red,
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
              onTap: (_, __) => _popupController.hideAllPopups(),
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
<<<<<<< HEAD
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: const Size(40, 40),
                  markers: _markers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading) const ShimmerLoadingOverlay(),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopControls()),
=======
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

>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
          if (_showRequestsList || _listAnimationController.isAnimating)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              bottom: _selectedRequest != null ? 180 : 16,
              child: SlideTransition(
                position: _listSlideAnimation,
                child: FadeTransition(
                  opacity: _listOpacityAnimation,
                  child: _buildRequestsList(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: context.watch<AuthProvider>().isMechanic
          ? _buildMechanicFAB()
          : _buildOwnerFAB(),
=======

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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
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
          if (request.carModel != null || request.carPlate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  if (request.carModel != null)
                    Chip(
                      label: Text(request.carModel!),
                      backgroundColor: Colors.blue[50],
                    ),
                  const SizedBox(width: 8),
                  if (request.carPlate != null)
                    Chip(
                      label: Text(request.carPlate!),
                      backgroundColor: Colors.green[50],
                    ),
                ],
              ),
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
