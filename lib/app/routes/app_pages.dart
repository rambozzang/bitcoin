import 'package:bitsumb2/app/modules/bindings/upbit/UpbitChart_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitList_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitOrder_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTrade_Binding.dart';
import 'package:bitsumb2/app/modules/views/bithumb/BithumbList_view.dart';
import 'package:bitsumb2/app/modules/views/bithumb/BithumbMain_view.dart';
import 'package:bitsumb2/app/modules/views/main/home_view.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitList_Binding.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitChart_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitList_view.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitMain_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTicker_Binding.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitMain_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitOrder_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTiker_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTrade_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitApi_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      //    binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.STOCKMAIN,
      page: () => BithumbkMainView(),
      //   binding: WebSocketBinding(),
    ),
    GetPage(
      name: _Paths.STOCKLIST,
      page: () => BithumbListView(),
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.UpbitMain,
      page: () => UpbitMainView(),
      binding: UpbitMainBinding(),
    ),
    GetPage(
      name: _Paths.UpbitList,
      page: () => UpbitListView(),
      binding: UpbitListBinding(),
    ),
    GetPage(
      name: _Paths.UpbitTiker,
      page: () => UpbitTikerView(),
      binding: UpbitTickerBinding(),
    ),
    GetPage(
      name: _Paths.UpbitOrder,
      page: () => UpbitOrderView(),
      binding: UpbitOrderBinding(),
    ),
    GetPage(
      name: _Paths.UpbitTrade,
      page: () => UpbitTradeView(),
      binding: UpbitTradeBinding(),
    ),
    GetPage(
      name: _Paths.UpbitChart,
      page: () => UpbitChartView(),
      binding: UpbitChartBinding(),
    ),
    GetPage(
      name: _Paths.UpbitApitest,
      page: () => UpbitApiView(),
      // binding: Get.lazyPut<UpbitChartController>(
      // () => UpbitChartController(),
    ),
  ];
}
