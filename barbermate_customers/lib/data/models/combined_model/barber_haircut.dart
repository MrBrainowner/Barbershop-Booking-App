import 'package:barbermate_customers/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate_customers/data/models/review_model/review_model.dart';

import '../user_authenthication_model/barbershop_model.dart';

class BarbershopHaircut {
  final BarbershopModel barbershop;
  final List<HaircutModel> haircuts;
  final List<ReviewsModel> review;

  BarbershopHaircut({
    required this.barbershop,
    required this.haircuts,
    required this.review,
  });

  // Empty method for BarbershopCombinedModel
  static BarbershopHaircut empty() {
    return BarbershopHaircut(
      barbershop:
          BarbershopModel.empty(), // Use the empty method of BarbershopModel
      haircuts: [],
      review: [],
    );
  }
}
