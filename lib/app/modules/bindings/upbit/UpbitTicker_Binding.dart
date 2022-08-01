import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitTikerController.dart';
import 'package:get/get.dart';

class UpbitTickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpbitMainController>(
      () => UpbitMainController(),
    );
    // Get.lazyPut<UpbitTikerController>(
    //   () => UpbitTikerController(),
    // );
  }
}
