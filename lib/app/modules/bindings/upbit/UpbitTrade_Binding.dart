import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitTradeController.dart';
import 'package:get/get.dart';

class UpbitTradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpbitMainController>(
      () => UpbitMainController(),
    );
    // Get.lazyPut<UpbitTradeController>(
    //   () => UpbitTradeController(),
    // );
  }
}
