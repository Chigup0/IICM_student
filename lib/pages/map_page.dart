import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSM Simple Map',
      debugShowCheckedModeBanner: false,
      home: const SimpleMapPage(),
    );
  }
}

enum PlaceType { location, eatery }

class Place {
  final String name;
  final LatLng coordinates;
  final PlaceType type;

  Place({required this.name, required this.coordinates, required this.type});
}

class SimpleMapPage extends StatefulWidget {
  const SimpleMapPage({super.key});
  @override
  State<SimpleMapPage> createState() => _SimpleMapPageState();
}

class _SimpleMapPageState extends State<SimpleMapPage> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final PermissionStatus permission = await _location.requestPermission();
      if (permission == PermissionStatus.granted) {
        final LocationData locationData = await _location.getLocation();
        setState(() {
          _userLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  // Sample places - easily add more
  final List<Place> _places = [
    Place(
      name: 'IITK Main Gate',
      coordinates: LatLng(26.5123, 80.2333),
      type: PlaceType.location,
    ),
    Place(
      name: 'OAT (Open Air Theatre)',
      coordinates: LatLng(26.5092, 80.2290),
      type: PlaceType.location,
    ),
    Place(
      name: 'Domino\'s Pizza',
      coordinates: LatLng(26.5052, 80.2295),
      type: PlaceType.eatery,
    ),
    Place(
      name: 'Cafe Coffee Day',
      coordinates: LatLng(26.5100, 80.2350),
      type: PlaceType.eatery,
    ),
  ];

  void _showPlaceDetails(Place place) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(place.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${place.type == PlaceType.eatery ? 'Eating Place' : 'Location'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Latitude: ${place.coordinates.latitude.toStringAsFixed(4)}'),
            const SizedBox(height: 4),
            Text(
              'Longitude: ${place.coordinates.longitude.toStringAsFixed(4)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerIcon(PlaceType type) {
    return type == PlaceType.eatery
        ? const Icon(Icons.restaurant, color: Colors.orange, size: 40)
        : const Icon(Icons.location_on, color: Colors.red, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _places.first.coordinates,
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.iicm_scan.app',
          ),

          // Markers with labels
          MarkerLayer(
            markers: [
              // User location marker (if available)
              if (_userLocation != null)
                Marker(
                  point: _userLocation!,
                  width: 60,
                  height: 60,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ],
                  ),
                ),

              // Other places
              ..._places
                  .map(
                    (place) => Marker(
                      point: place.coordinates,
                      width: 120,
                      height: 100,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showPlaceDetails(place),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                place.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => _showPlaceDetails(place),
                            child: _buildMarkerIcon(place.type),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
