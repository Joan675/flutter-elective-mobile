// lib/screens/map_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../services/nominatim_service.dart';
import '../static/app_sidebar.dart';
import '../services/directions_service.dart';
import '../data/sample_pharmacies.dart';

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

/* ──────────────────────────────────────── MAP SCREEN ─────────────────────── */
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /* --------------- controllers & state --------------- */
  final MapController _mapController = MapController();
  final PanelController _panelController = PanelController();
  final TextEditingController _searchCtrl = TextEditingController();

  LatLng? _currentLoc;
  List<Pharmacy> _pharmacies = [];
  List<Pharmacy> _nearest = [];
  List<LatLng> _routePoints = [];
  Pharmacy? _selected;

  final Distance _distance = const Distance();

  /* --------------- init --------------- */
  @override
  void initState() {
    super.initState();
    _pharmacies = List.from(samplePharmacies);
    _getCurrentLocation();
  }

  /* --------------- geolocation --------------- */
  Future<void> _getCurrentLocation() async {
    // permissions & service
    if (!await Geolocator.isLocationServiceEnabled()) return;
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLoc = LatLng(pos.latitude, pos.longitude);
      _sortNearest();
    });
  }

  /* --------------- sort pharmacies by distance --------------- */
  void _sortNearest() {
    if (_currentLoc == null) return;
    _pharmacies.sort((a, b) =>
        _distance(_currentLoc!, a.location).compareTo(_distance(_currentLoc!, b.location)));
    _nearest = _pharmacies.take(3).toList();
  }

  /* --------------- search with Nominatim --------------- */
  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) return;
    final LatLng? coords = await NominatimService.getCoordinatesFromAddress(query.trim());
    if (coords != null) {
      _mapController.move(coords, 16); // zoom to searched place
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Moved to “$query”')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location “$query” not found')),
      );
    }
  }

  /* --------------- UI --------------- */
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
        title: const Text('Find Stores'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(icon: const Icon(Icons.favorite), onPressed: () {}),
        ],
      ),
      body: _currentLoc == null
          ? const Center(child: CircularProgressIndicator())
          : SlidingUpPanel(
              controller: _panelController,
              minHeight: 140,
              maxHeight: _selected != null ? 320 : 260,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              panel: _selected == null ? _nearestPanel() : _detailPanel(_selected!),
              body: Column(
                children: [
                  /* -------- search bar -------- */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: TextField(
                      controller: _searchCtrl,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search place…',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  /* -------- map -------- */
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLoc!,
                        initialZoom: 15,
                        onTap: (_, __) => setState(() => _selected = null),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            /* user marker */
                            Marker(
                              point: _currentLoc!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
                            ),
                            /* pharmacy markers */
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
                        ),PolylineLayer(
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
                ],
              ),
            ),
    );
  }

  /* --------------- sliding‑panel content --------------- */
  Widget _nearestPanel() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nearest Store',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ..._nearest.map((p) {
            final km = _distance(_currentLoc!, p.location) / 1000;
            final mins = (km / 0.4) * 60; // rough 24 km/h walking ≈ 0.4 km/min
            return Card(
              child: ListTile(
                leading: const Icon(Icons.visibility),
                title: Text(p.name,
                    style: const TextStyle(color: Colors.lightBlue)),
                trailing: Text('${mins.toStringAsFixed(0)} min'),
                onTap: () {
                  setState(() => _selected = p);
                  _panelController.open();
                  _mapController.move(p.location, 16);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _detailPanel(Pharmacy p) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              IconButton(
                  onPressed: () => setState(() => _selected = null),
                  icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 8),
          Text(p.address),
          Text(p.contact),
          Text('Hours: ${p.hours}'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                if (_currentLoc == null || _selected == null) return;

                final route = await DirectionsService.getRoute(_currentLoc!, _selected!.location);

                if (route.isNotEmpty) {
                  final bounds = LatLngBounds.fromPoints(route);

                  setState(() {
                    _routePoints = route;
                  });

                  // Move to the center of the route and zoom out a bit manually
                  _mapController.move(bounds.center, 14); // Adjust zoom as needed
                }
              },
              child: const Text('Show Direction'),
            ),
          ),
        ],
      ),
    );
  }

  /* --------------- cleanup --------------- */
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
