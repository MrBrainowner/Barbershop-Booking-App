import 'package:barbermate_customers/features/customer/controllers/get_directions_controller/get_directions_controller.dart';
import 'package:barbermate_customers/features/customer/views/test_map/map_panel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class MapWidgetTest extends StatelessWidget {
  const MapWidgetTest({super.key});

  @override
  Widget build(BuildContext context) {
    final GetDirectionsController controller = Get.find();
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    final PanelController panelController = PanelController();

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return Stack(
              children: [
                SlidingUpPanel(
                  controller: panelController,
                  maxHeight: panelHeightOpen,
                  minHeight: panelHeightClosed,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  parallaxEnabled: true,
                  body: SafeArea(
                    child: FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        initialCenter: controller
                                .selectedBarbershopLocation.value ??
                            const LatLng(7.44659415181318, 125.80925506524625),
                        initialZoom: 12.3,
                        cameraConstraint: CameraConstraint.containCenter(
                            bounds: controller.bounds),
                        minZoom: 12.3,
                        interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.pinchZoom |
                                InteractiveFlag.drag),
                      ),
                      children: [
                        TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY200eDJmaGg1MGlrbzJqcXZjenF0OWpwaCJ9.lc2Iye0e4SRDrU3LMO8DGg',
                            additionalOptions: const {
                              'accessToken':
                                  'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY200eDJmaGg1MGlrbzJqcXZjenF0OWpwaCJ9.lc2Iye0e4SRDrU3LMO8DGg',
                              'id': 'mapbox/light-v11'
                            }),
                        PolylineLayer(
                          polylines: [
                            if (controller.routeCoordinates.isNotEmpty)
                              Polyline(
                                points: controller.routeCoordinates,
                                strokeWidth: 4.0,
                                useStrokeWidthInMeter: true,
                                borderStrokeWidth: 3.0,
                                borderColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).primaryColor,
                              ),
                          ],
                        ),
                        MarkerLayer(
                          markers: _buildMarkers(),
                        ),
                        CurrentLocationLayer(
                          alignPositionOnUpdate: AlignOnUpdate.once,
                          alignDirectionOnUpdate: AlignOnUpdate.never,
                          style: LocationMarkerStyle(
                            marker: DefaultLocationMarker(
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.navigation,
                                color: Colors.white,
                              ),
                            ),
                            markerSize: const Size(40, 40),
                            markerDirection: MarkerDirection.heading,
                          ),
                        )
                      ],
                    ),
                  ),
                  backdropEnabled: true,
                  backdropTapClosesPanel: true,
                  panelBuilder: (controller) => MapPanel(
                    panelController: panelController,
                    controller: controller,
                  ),
                ),
              ],
            );
          }),
          Positioned(
              left: 20,
              top: 40,
              child: GestureDetector(
                  onTap: () => Get.back(), child: const iconoir.ArrowLeft()))
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final GetDirectionsController controller = Get.find();
    final barbershops = controller.barbershopsController.barbershop;

    return [
      ...barbershops.asMap().entries.map((entry) {
        final index = entry.key;
        final barbershop = barbershops[index];
        final location = LatLng(barbershop.latitude, barbershop.longitude);
        final logoUrl = barbershop.barbershopProfileImage;

        return Marker(
          point: location,
          width: 100.0,
          height: 80.0,
          child: Column(
            children: [
              Flexible(
                  child: Text(
                barbershop.barbershopName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
              GestureDetector(
                onTap: () async {
                  final distance = controller.barbershopDistances[index]
                          ?.toStringAsFixed(2) ??
                      'Turn on location...';
                  controller.selectBarbershop(location);
                  controller.showBarbershopDetails(
                      location,
                      barbershop.barbershopName,
                      distance,
                      barbershop.barbershopBannerImage,
                      barbershop);
                },
                child: logoUrl.isEmpty
                    ? CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey.shade400,
                        child: const iconoir.QuestionMark(height: 30),
                      )
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundImage: CachedNetworkImageProvider(logoUrl)),
              )
            ],
          ),
        );
      }),
    ];
  }
}
