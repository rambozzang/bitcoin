import 'package:bitsumb2/app/modules/controllers/upbit/UpbitChartController.dart';
import 'package:get/get.dart';

class UpbitChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpbitChartController>(
      () => UpbitChartController(),
    );
  }
}
