import 'package:barbermate/features/auth/controllers/signup_controller/location_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class SearchBarr extends StatelessWidget {
  final Function(String, double, double) onLocationSelected;

  const SearchBarr({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationSearchController());
    final textController = TextEditingController();

    return Column(
      children: [
        Obx(() {
          textController.text = controller.searchQuery.value;
          textController.selection = TextSelection.fromPosition(
            TextPosition(offset: textController.text.length),
          );

          return TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Search Location',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.clear();
                        controller.searchQuery.value = '';
                        controller.searchResults.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (query) {
              controller.searchQuery.value = query;
              controller.searchLocation(query);
            },
          );
        }),
        Obx(() {
          if (controller.isSearching.value) {
            return const CircularProgressIndicator();
          } else if (controller.searchResults.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final result = controller.searchResults[index];
                final address = result['place_name'];
                final lat = result['geometry']['coordinates'][1];
                final lng = result['geometry']['coordinates'][0];

                return ListTile(
                  title: Text(address),
                  onTap: () {
                    controller.setSelectedLocation(address, LatLng(lat, lng));
                    onLocationSelected(address, lat, lng);
                  },
                );
              },
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }
}
