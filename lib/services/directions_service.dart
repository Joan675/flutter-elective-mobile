// lib/services/directions_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DirectionsService {
  /// Your ORS API‑key (put it in .env → ORS_API_KEY=…)
  static final String _apiKey = dotenv.env['ORS_API_KEY']!;

  /// Ask ORS to give us GeoJSON so we don’t get the old encoded string by
  /// default, but we’ll still handle every possible format.
  static const String _baseUrl =
      'https://api.openrouteservice.org/v2/directions/foot-walking'
      '?geometry_format=geojson';

  /// Returns a list of `LatLng` points suitable for a `PolylineLayer`.
  static Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': _apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coordinates': [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude],
        ],
        // we don’t need turn‑by‑turn instructions for a simple polyline
        'instructions': false,
      }),
    );

    if (res.statusCode != 200) {
      print('[ORS] error ${res.statusCode}: ${res.body}');
      return [];
    }

    final data = jsonDecode(res.body);

    /* ──────────── robust geometry parser ──────────── */
    List coords = [];

    final route = (data['routes'] as List?)?.first;
    if (route == null) return [];

    final geom = route['geometry'];
    // 1️⃣ GeoJSON map  { type: LineString, coordinates: [...] }
    if (geom is Map && geom['coordinates'] is List) {
      coords = geom['coordinates'] as List;
    }
    // 2️⃣ Already a list of [lon,lat] pairs
    else if (geom is List) {
      coords = geom;
    }
    // 3️⃣ Encoded polyline string (fallback for very old responses)
    else if (geom is String) {
      coords = _decodePolyline(geom);
    }

    if (coords.isEmpty) {
      print('[ORS] unable to parse route geometry');
      return [];
    }

    // convert [lon,lat] → LatLng(lat, lon)
    return coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
  }

  /* ──────────── helpers ──────────── */

  /// Decode an encoded polyline string into a List<List<double>>
  static List<List<double>> _decodePolyline(String poly) {
    int index = 0, lat = 0, lng = 0;
    final len = poly.length;
    final List<List<double>> points = [];

    while (index < len) {
      int shift = 0, result = 0, b;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add([lng * 1e-5, lat * 1e-5]); // keep [lon,lat] order
    }
    return points;
  }
}
