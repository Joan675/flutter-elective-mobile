import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NominatimService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _headers = {
    'User-Agent': 'Medisync/1.0 (openstreetmap.acc@gmail.com)' // REQUIRED
  };

  /// Forward geocoding: Address or place name → LatLng
  static Future<LatLng?> getCoordinatesFromAddress(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&limit=1',
    );

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']);
          final lon = double.tryParse(data[0]['lon']);
          if (lat != null && lon != null) {
            return LatLng(lat, lon);
          }
        }
      } else {
        print('Nominatim forward error: ${response.statusCode}');
      }
    } catch (e) {
      print('Nominatim forward exception: $e');
    }

    return null;
  }

  /// Reverse geocoding: LatLng → Address or place name
  static Future<String?> getPlaceFromCoordinates(LatLng latLng) async {
    final url = Uri.parse(
      '$_baseUrl/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json',
    );

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Unknown location';
      } else {
        print('Nominatim reverse error: ${response.statusCode}');
      }
    } catch (e) {
      print('Nominatim reverse exception: $e');
    }

    return null;
  }
}
