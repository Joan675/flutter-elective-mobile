// lib/screens/map_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../services/directions_service.dart';
import '../data/sample_pharmacies.dart';
import '../static/app_sidebar.dart';

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String hours;
  final LatLng location;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.hours,
    required this.location,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PanelController _panelController = PanelController();

  LatLng? _currentLoc;
  List<Pharmacy> _pharmacies = [];
  List<Pharmacy> _nearest = [];
  List<LatLng> _routePoints = [];
  Pharmacy? _selected;
  bool _followUser = true;

  final Distance _distance = const Distance();

  @override
  void initState() {
    super.initState();
    _pharmacies = List.from(samplePharmacies);
    _startListeningToLocationChanges();
  }

  StreamSubscription<Position>? _positionStream;

  void _startListeningToLocationChanges() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever)
        return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position pos) {
      final newLoc = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentLoc = newLoc;
        _sortNearest();
        if (_followUser) {
          _mapController.move(
            _offsetLatLng(newLoc),
            _mapController.camera.zoom,
          );
        }
      });
    });
  }

  void _sortNearest() {
    if (_currentLoc == null) return;
    _pharmacies.sort(
      (a, b) => _distance(
        _currentLoc!,
        a.location,
      ).compareTo(_distance(_currentLoc!, b.location)),
    );
    _nearest = _pharmacies.take(3).toList();
  }

  LatLng _offsetLatLng(LatLng original, {double offsetInMeters = -250}) {
    final offsetLat = _distance.offset(
      original,
      offsetInMeters,
      0,
    ); // 0° = north
    return offsetLat;
  }

  void _fitBounds(LatLngBounds bounds) {
    final center = bounds.center;

    // Crude zoom estimation based on bounds size
    const paddingFactor = 0.001;
    final latDiff = (bounds.north - bounds.south).abs() + paddingFactor;
    final lngDiff = (bounds.east - bounds.west).abs() + paddingFactor;

    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    final zoom = (16 - (maxDiff * 100)).clamp(5, 18).toDouble();

    // Calculate vertical offset based on screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalOffset = screenHeight < 700 ? 0.002 : 0.0035;

    final offsetCenter = LatLng(
      center.latitude + verticalOffset, // move up (north)
      center.longitude,
    );

    _mapController.move(offsetCenter, zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        leading: Builder(
          builder:
              (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
        ),
        title: const Text('Nearby Pharmacies'),
        backgroundColor: const Color(0xFF81D4FA),
      ),
      body:
          _currentLoc == null
              ? const Center(child: CircularProgressIndicator())
              : SlidingUpPanel(
                controller: _panelController,
                minHeight: 140,
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.35, // ← or higher if needed
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                panel:
                    _selected == null
                        ? _nearestPanel()
                        : _detailPanel(_selected!),
                body: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLoc!,
                    initialZoom: 15,
                    onTap: (_, __) => setState(() => _selected = null),
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture && _followUser) {
                        setState(() {
                          _followUser = false;
                        });
                      }
                    },
                  ),

                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.example.yourapp',
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLoc!,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _followUser = true;
                              });
                              _mapController.move(
                                _offsetLatLng(_currentLoc!),
                                _mapController.camera.zoom,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Following your location"),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                        ),

                        ..._pharmacies.map(
                          (p) => Marker(
                            point: p.location,
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selected = p);
                                _panelController.open();
                                _mapController.move(
                                  _offsetLatLng(p.location),
                                  _mapController.camera.zoom,
                                );
                              },
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.cyan,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        if (_routePoints.isNotEmpty)
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5,
                            color: Colors.blueAccent,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _nearestPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nearest Pharmacies',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._nearest.map((p) {
                      final dist = _distance(
                        _currentLoc!,
                        p.location,
                      ); // in meters
                      final distLabel =
                          dist >= 1000
                              ? '${(dist / 1000).toStringAsFixed(2)} km'
                              : '${dist.toStringAsFixed(0)} m';
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(
                            Icons.local_pharmacy,
                            color: Colors.lightBlue,
                          ),
                          title: Text(
                            p.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue,
                            ),
                          ),
                          subtitle: Text(
                            p.address,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            distLabel,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          onTap: () {
                            setState(() {
                              _selected = p;
                              _followUser = false;
                            });
                            _panelController.open();
                            _mapController.move(
                              _offsetLatLng(p.location),
                              _mapController.camera.zoom,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailPanel(Pharmacy p) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* --- Header --- */
          Row(
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _selected = null),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /* --- Info Card --- */
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow(Icons.location_on, p.address),
                  const SizedBox(height: 8),
                  _detailRow(Icons.phone, p.contact),
                  const SizedBox(height: 8),
                  _detailRow(Icons.access_time, 'Hours: ${p.hours}'),
                ],
              ),
            ),
          ),

          const Spacer(),

          /* --- Show Directions Button --- */
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.directions, size: 20, color: Colors.white),
              label: const Text(
                'Show Directions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (_currentLoc == null || _selected == null) return;

                final route = await DirectionsService.getRoute(
                  _currentLoc!,
                  _selected!.location,
                );

                if (route.isNotEmpty) {
                  final bounds = LatLngBounds.fromPoints(route);
                  setState(() {
                    _routePoints = route;
                  });

                  _fitBounds(bounds);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.lightBlue, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
