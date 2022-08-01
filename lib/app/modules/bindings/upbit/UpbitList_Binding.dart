import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:get/get.dart';

class UpbitListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpBitListController>(
      () => UpBitListController(),
    );
  }
}
