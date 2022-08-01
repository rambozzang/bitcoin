import 'package:bitsumb2/app/modules/controllers/Candle_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class CandleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandelController>(
      () => CandelController(),
    );
  }
}
