import 'package:barbermate_customers/features/customer/controllers/get_directions_controller/get_directions_controller.dart';
import 'package:barbermate_customers/features/customer/views/widgets/get_directions/barbershop_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPanel extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const MapPanel(
      {super.key, required this.controller, required this.panelController});

  @override
  Widget build(BuildContext context) {
    final GetDirectionsController ccontroller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          buildDragHandle(),
          const SizedBox(
            height: 20,
          ),
          buildButton(ccontroller),
          Obx(() {
            if (ccontroller.barbershopDistances.isEmpty) {
              ccontroller.calculateAllDistances();
              return const Center(child: CircularProgressIndicator());
            }

            final barbershops = ccontroller.barbershopsController.barbershop;
            final distances = ccontroller.barbershopDistances.values.toList();
            final sortedKeys = ccontroller.barbershopDistances.keys.toList();

            return Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: barbershops.length,
                itemBuilder: (context, index) {
                  final barbershop = barbershops[sortedKeys[index]];
                  final distance = distances[index].toStringAsFixed(2);

                  return BarbershopCard(
                    profile: barbershop.barbershopProfileImage,
                    name: barbershop.barbershopName,
                    distance: '$distance km',
                    onTap: () async {
                      var locations =
                          LatLng(barbershop.latitude, barbershop.longitude);
                      ccontroller.selectBarbershop(locations);
                      ccontroller.showBarbershopDetails(
                          locations,
                          barbershop.barbershopName,
                          distance,
                          barbershop.barbershopBannerImage,
                          barbershop);
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildDragHandle() => Center(
        child: GestureDetector(
          onTap: () {
            panelController.isPanelOpen
                ? panelController.close()
                : panelController.open();
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: 50,
            height: 5,
          ),
        ),
      );

  Widget buildButton(GetDirectionsController ccontroller) => Row(
        children: [
          Obx(() {
            final buttonText = ccontroller.isAscending.value
                ? 'Nearest to Farthest'
                : 'Farthest to Nearest';
            return Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ccontroller.toggleSortingOrder();
                },
                child: Text(buttonText),
              ),
            );
          }),
        ],
      );
}
