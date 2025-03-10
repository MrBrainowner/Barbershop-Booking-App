import 'dart:convert';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DirectionsService extends GetxController {
  static DirectionsService get instance => Get.find();
  static const String _accessToken =
      'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig';

  Future<double?> getDistance(
      LatLng userLocation, LatLng barbershopLocation) async {
    final url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${userLocation.longitude},${userLocation.latitude};'
        '${barbershopLocation.longitude},${barbershopLocation.latitude}?annotations=distance&access_token=$_accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final distance = data['routes'][0]['legs'][0]['distance'] as double;
        return distance / 1000; // Convert to kilometers
      }
    } catch (e) {
      throw Exception("Error fetching directions: $e");
    }
    return null;
  }

  Future<List<LatLng>> fetchDirections(LatLng start, LatLng destination) async {
    final url = 'https://api.mapbox.com/directions/v5/mapbox/walking/'
        '${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&overview=full&access_token=$_accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List;
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      }
    } catch (e) {
      throw Exception("Error fetching directions: $e");
    }
    return [];
  }
}
