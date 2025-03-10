import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/stepper_controller/stepper_controller.dart';
import 'stepper_contents/step_1.dart';
import 'stepper_contents/step_2.dart';
import 'stepper_contents/step_3.dart';

class BarbershopSignUpPage extends StatelessWidget {
  const BarbershopSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stepperController = Get.put(StepperController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Barbershop Account',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Obx(() {
        return Stepper(
          type: StepperType.horizontal,
          currentStep: stepperController.currentStep.value,
          onStepTapped: (int index) {
            // Allow step tap only if it is the current or previous validated steps
            if (stepperController.canTapStep(index)) {
              stepperController.currentStep.value = index;
            }
          },
          onStepContinue: stepperController.nextStep,
          onStepCancel: stepperController.previousStep,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Next'),
                  ),
                ),
              ],
            );
          },
          steps: [
            Step(
              isActive: stepperController.currentStep.value >= 0,
              title: const Text('Account'),
              content: const Step1(),
            ),
            Step(
              title: const Text('Location'),
              isActive: stepperController.currentStep.value >= 1,
              content: const Step2(),
            ),
            Step(
              title: const Text('Complete'),
              isActive: stepperController.currentStep.value >= 2,
              content: const Step3(),
            )
          ],
        );
      }),
    );
  }
}
