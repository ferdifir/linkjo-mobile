import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:linkjo/utils/log.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Map<String, dynamic>?> getAddressFromLocation(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'FlutterApp/1.0 (ferdifir.dev@gmail.com)',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Log.d('Failed to load location data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Log.d('Error: $e');
      return null;
    }
  }
}
