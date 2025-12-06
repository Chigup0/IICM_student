import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../constants/colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  late final CameraPosition _initialCamera;
  final Set<Marker> _markers = {};
  final Location _locationService = Location();
  LatLng? _currentLocation;
  bool _loadingLocation = false;

  // Static location coordinate: 26.505223, 80.229806
  final List<Map<String, dynamic>> _preset = [
    {
      'id': 'iicm_location',
      'title': 'Inter IIT Cult Meet 8.0',
      'lat': 26.505223,
      'lng': 80.229806,
    },
    {
      'id': 'hall-1',
      'title': 'hall of res-1',
      'lat': 26.506366,
      'lng': 80.220930,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Create markers from preset list
    for (final item in _preset) {
      final id = item['id'] as String;
      final lat = (item['lat'] as num).toDouble();
      final lng = (item['lng'] as num).toDouble();
      final title = item['title'] as String?;
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: title),
          onTap: () {
            _mapController.showMarkerInfoWindow(MarkerId(id));
          },
          alpha: 1.0,
        ),
      );
    }

    // Set initial camera position to the location
    _initialCamera = CameraPosition(
      target: LatLng(26.505223, 80.229806),
      zoom: 15.0,
    );

    // Initialize location on load
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await _locationService.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationService.requestPermission();
      if (permission != PermissionStatus.granted) {
        _showLocationDeniedDialog();
        return;
      }
    }

    try {
      final loc = await _locationService.getLocation();
      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          _currentLocation = LatLng(loc.latitude!, loc.longitude!);
        });
      }

      // Listen to location changes
      _locationService.onLocationChanged.listen((LocationData newLoc) {
        if (newLoc.latitude == null || newLoc.longitude == null) return;
        setState(() {
          _currentLocation = LatLng(newLoc.latitude!, newLoc.longitude!);
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Location Permission Denied',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: const Text(
          'This app needs location access to show your current position on the map. Please enable it in settings.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _locationService.requestPermission();
              Navigator.pop(context);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _moveToCurrentLocation() async {
    if (_currentLocation == null) {
      setState(() => _loadingLocation = true);
      try {
        final loc = await _locationService.getLocation();
        if (loc.latitude != null && loc.longitude != null) {
          final newLatLng = LatLng(loc.latitude!, loc.longitude!);
          setState(() => _currentLocation = newLatLng);
          _mapController.animateCamera(CameraUpdate.newLatLng(newLatLng));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting current location: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _loadingLocation = false);
        }
      }
    } else {
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    for (final item in _preset) {
      _mapController.showMarkerInfoWindow(MarkerId(item['id'] as String));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCamera,
            markers: _markers,
            mapType: MapType.normal,
            myLocationEnabled: _currentLocation != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            gestureRecognizers: {
              Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
              Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
              Factory<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
              ),
            },
            compassEnabled: true,
          ),
          // Custom location button
          Positioned(
            bottom: 120,
            right: 16,
            child: FloatingActionButton(
              onPressed: _moveToCurrentLocation,
              backgroundColor: AppColors.primaryAccent,
              child: _loadingLocation
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
