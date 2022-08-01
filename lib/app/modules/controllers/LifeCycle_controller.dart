import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  @override
  void onDetached() {
    print("onDetached!! 1");
    print("onDetached!! 2");
    print("onDetached!! 3");
  }

  // background 로 넘어갔을떄...
  @override
  void onInactive() {
    print("onInactive!! 1 ");
    print("onInactive!! 2");
    print("onInactive!! 3");
  }

  // background 로 넘어갔을떄...
  @override
  void onPaused() {
    print("onPaused!! 1");
    print("onPaused!! 2");
    print("onPaused!! 3");
  }

  // foreground 로 넘어갔을떄...
  @override
  void onResumed() {
    print("onResumed!! 1");
    print("onResumed!! 2");
    print("onResumed!! 3");

    //첫 메인화면 소켓서비스는 무조건 재접속처리
    Get.find<UpBitListController>().reSocketInit();

    // 코인 상세 페이지에서 background로 넘어갔을때는 코인상세 소켓도 재접속 처리 한다.
    if (Get.find<UpbitMainController>().initdata.value) {
      Get.find<UpbitMainController>().onInit();
    }
  }
}
