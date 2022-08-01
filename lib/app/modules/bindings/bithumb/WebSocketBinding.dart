import 'package:bitsumb2/app/modules/controllers/bithumb/WebSocketController.dart';
import 'package:get/get.dart';

class WebSocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebSocketController>(
      () => WebSocketController(),
    );
  }
}
