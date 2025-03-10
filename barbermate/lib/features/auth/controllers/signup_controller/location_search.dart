import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class LocationSearchController extends GetxController {
  var searchQuery = ''.obs;
  var searchResults = <dynamic>[].obs;
  var isSearching = false.obs;
  var selectedAddress = ''.obs;
  var selectedLatLng = LatLng(0.0, 0.0).obs;

  // Replace with your Mapbox Access Token
  final String mapboxToken =
      'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY200eDJmaGg1MGlrbzJqcXZjenF0OWpwaCJ9.lc2Iye0e4SRDrU3LMO8DGg';

  // Bounding box for Tagum City, Philippines
  final List<double> bbox = [125.8352, 7.4376, 126.0189, 7.7501];

  // Method to search locations using Mapbox Geocoding API
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?country=ph&proximity=ip&types=address%2Clocality&autocomplete=true&access_token=$mapboxToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        searchResults.assignAll(data['features']);
      }
    } catch (e) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  // Method to set selected location
  void setSelectedLocation(String address, LatLng latLng) {
    selectedAddress.value = address;
    selectedLatLng.value = latLng;
    searchQuery.value = address; // Update search bar query
    searchResults.clear(); // Clear suggestions
  }
}
