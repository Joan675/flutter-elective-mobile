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

  final Distance _distance = const Distance();

  @override
  void initState() {
    super.initState();
    _pharmacies = List.from(samplePharmacies);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLoc = LatLng(pos.latitude, pos.longitude);
      _sortNearest();
    });

    // Open panel after nearest is computed
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _panelController.open();
    });
  }

  void _sortNearest() {
    if (_currentLoc == null) return;
    _pharmacies.sort((a, b) =>
        _distance(_currentLoc!, a.location).compareTo(_distance(_currentLoc!, b.location)));
    _nearest = _pharmacies.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Nearby Pharmacies'),
        backgroundColor: const Color(0xFF81D4FA),
      ),
      body: _currentLoc == null
          ? const Center(child: CircularProgressIndicator())
          : SlidingUpPanel(
              controller: _panelController,
              minHeight: 140,
              maxHeight: MediaQuery.of(context).size.height * 0.35, // ← or higher if needed
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              panel: _selected == null ? _nearestPanel() : _detailPanel(_selected!),
              body: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLoc!,
                  initialZoom: 15,
                  onTap: (_, __) => setState(() => _selected = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.example.yourapp',
                  ),

                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLoc!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
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
                            },
                            child: const Icon(Icons.location_on, color: Colors.cyan, size: 36),
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
                    const Text('Nearest Pharmacies',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ..._nearest.map((p) {
                      final dist = _distance(_currentLoc!, p.location); // in meters
                      final distLabel = dist >= 1000
                          ? '${(dist / 1000).toStringAsFixed(2)} km'
                          : '${dist.toStringAsFixed(0)} m';
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(Icons.local_pharmacy, color: Colors.lightBlue),
                          title: Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, color: Colors.lightBlue)),
                          subtitle: Text(p.address, style: const TextStyle(fontSize: 12)),
                          trailing: Text(distLabel, style: const TextStyle(color: Colors.black54)),
                          onTap: () {
                            setState(() => _selected = p);
                            _panelController.open();
                            _mapController.move(p.location, 16);
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
            )
          ],
        ),
        const SizedBox(height: 10),

        /* --- Info Card --- */
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            icon: const Icon(Icons.directions, size: 20, color: Colors.white,),
            label: const Text('Show Directions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              if (_currentLoc == null || _selected == null) return;
              final route = await DirectionsService.getRoute(_currentLoc!, _selected!.location);
              if (route.isNotEmpty) {
                final bounds = LatLngBounds.fromPoints(route);
                setState(() {
                  _routePoints = route;
                });
                _mapController.move(bounds.center, 14);
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
    super.dispose();
  }
}