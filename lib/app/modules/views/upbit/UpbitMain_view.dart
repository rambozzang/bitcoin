import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitChart_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitOrder_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTicker_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTrade_Binding.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/modules/views/minichart/chart_home_page.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitChart_view%20copy.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitChart_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitOrder_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTiker_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTrade_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/upbitInfo_view.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:bitsumb2/app/utils/fade_stack.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class UpbitMainView extends GetView<UpbitMainController> {
  // final UpbitWebSocketController socketController =
  //     Get.put(UpbitWebSocketController());

  //금액 포멧
  var f = NumberFormat('###,###,###,###');
  var f2 = NumberFormat('###,###,###,###.00#');

  late ResTickerVo _resTickerVo = new ResTickerVo();

  // 코인은 자릿수
  int coinNum = 2;

  int tradeListLimit = 35;

  final Key mainkey = PageStorageKey('mainkey');
  final Key listKey1 = PageStorageKey('list1'); // 첫번째 tab key
  var listKey2 = GlobalKey<NavigatorState>(); // 두번째 tab key
  final Key listKey3 = PageStorageKey('list3'); // 세번째 tab key
  final Key listKey4 = PageStorageKey('list4'); // 세번째 tab key
  final Key listKey5 = PageStorageKey('list5'); // 세번째 tab key

  final List<Tab> tabs = [
    Tab(height: 50, child: Text("주문")),
    Tab(height: 50, child: Text("호가")),
    Tab(height: 50, child: Text("차트")),
    Tab(height: 50, child: Text("시세")),
    Tab(height: 50, child: Text("정보")),
  ];

  // indexedStack 에서 초기에 모든 화면이 로드되는거 방지하기 위함.
  // 3,4, 5번째는 탭바클릭시 로드 처리한다.
  final tabviews = <Widget>[
    UpbitOrderView(),
    UpbitTikerView(),
    Center(child: Text("Loading...")),
    UpbitTradeView(),
    Center(child: Text("Loading...")),
    // UpbitTikerView(),
    // UpbitChartView(),
    // UpbitTradeView(),
    // UpbitInfoView(),
  ];

  //Widget get currentPage => pages[currentIndex()];

  final List<dynamic> tabviews1 = [
    GetNavigator(
      //      key: controller.navigatorKey,
      pages: [
        GetPage(
          name: "/UpbitOrder",
          page: () => UpbitOrderView(),
          binding: UpbitOrderBinding(),
        ),
      ],
    ),
    GetNavigator(
      //      key: controller.navigatorKey,
      pages: [
        GetPage(
          name: "/UpbitTiker",
          page: () => UpbitTikerView(),
          binding: UpbitTickerBinding(),
        ),
      ],
    ),
    GetNavigator(
      //      key: controller.navigatorKey,
      pages: [
        GetPage(
          name: "/UpbitChart",
          page: () => UpbitChartView(),
          binding: UpbitChartBinding(),
        ),
      ],
    ),
    GetNavigator(
      pages: [
        GetPage(
          name: "/UpbitTrade",
          page: () => UpbitTradeView(),
          binding: UpbitTradeBinding(),
        ),
      ],
    ),
    Text("정보"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(43.0),
        child: AppBar(
          elevation: 0.0,
          leading: IconButton(
            iconSize: 17,
            padding: const EdgeInsets.all(1.0),
            //   splashRadius: 5.0,
            icon: Icon(Icons.arrow_back_ios, color: Utils.bgcolor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.coinName}(${controller.coinCode.replaceAll("-", "/")})',
                // style: TextStyle(fontSize: 17, color: Colors.black),
                style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),

                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => Get.find<UpBitListController>()
                          .setFavoriteCoin(controller.coinCode),
                      icon: Icon(Icons.star_border_outlined),
                      color: Utils.bgcolor),
                  SizedBox(
                    width: 9,
                  ),
                  Icon(Icons.notifications_none, color: Utils.bgcolor),
                  SizedBox(
                    width: 9,
                  ),
                  Icon(Icons.copy_outlined, color: Utils.bgcolor),
                ],
              )
            ],
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
      ),
      body: getMainList(),
    );
  }

  // 상단 메인
  Widget getMainList() {
    return Column(
      children: [
        getTop(),
        Container(height: 25, child: getAnimatedText()),
        Container(
            constraints: BoxConstraints(maxHeight: 41.0),
            child: Material(
                color: Utils.bgcolor,
                child: TabBar(
                  onTap: controller.changeRootPageIndex,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  controller: controller.tabController,
                  tabs: tabs,
                ))),
        Expanded(
          child: getbodyNew(),
        ),
      ],
    );
  }

  Widget getbodyNew() {
    return Obx(() {
      // indexedStack 에서 초기에 모든 화면이 로드되는거 방지하기 위함.
      if (controller.pageIndex.value == 2) {
        tabviews[2] = UpbitChartView();
      }
      if (controller.pageIndex.value == 4) {
        tabviews[4] = UpbitInfoView();
        // tabviews[4] = UpbitChartViewBak();
      }
      return FadeIndexedStack(
        //key: ,
        index: controller.pageIndex.value,
        children: [...tabviews],
      );
    });
  }

  Widget getAnimatedText() {
    return Container(
      height: 20,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        color: Colors.white60,
        border: Border.all(width: 0.4, color: Colors.grey.shade400),
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          RotateAnimatedText(
            'BITFINEX   18,8373(W16,77)    KRAKEN   100(0.11) ',
            textAlign: TextAlign.start,
            alignment: Alignment.centerLeft,
            textStyle: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.normal,
            ),
            //  speed: const Duration(milliseconds: 500),
          ),
          RotateAnimatedText(
            'KRAKEN   100(0.11)',
            alignment: Alignment.centerLeft,
            textAlign: TextAlign.start,
            textStyle: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.normal,
            ),
            //  speed: const Duration(milliseconds: 500),
          ),
        ],
        totalRepeatCount: 4000,
        pause: const Duration(milliseconds: 600),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
    );
  }

  //상단 정보
  Widget getTop() {
    return Container(
      child: StreamBuilder<ResTickerVo>(
          stream: controller.streamTiker.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: 49,
              );
            }
            _resTickerVo = snapshot.data!;

            Color colr = Colors.red;

            late IconData icon;
            if (_resTickerVo.change == "RISE") {
              colr = Utils.upbgcolor;
              icon = Icons.arrow_drop_up;
            } else if (_resTickerVo.change == "EVEN") {
              colr = Colors.black;
              icon = Icons.arrow_drop_up;
            } else if (_resTickerVo.change == "FALL") {
              colr = Utils.downbgcolor;
              icon = Icons.arrow_drop_down;
            } else {
              colr = Utils.downbgcolor;
            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              height: 49,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //   padding: EdgeInsets.only(right: 1),
                    child: Icon(
                      Icons.navigate_before_sharp,
                      color: Colors.grey[300],
                      size: 23,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "${Utils.getMoneyformat(_resTickerVo.trade_price)}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colr),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              child: Text("전일대비 ",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${(_resTickerVo.signed_change_rate! * 100).toStringAsFixed(2)}%",
                              style: TextStyle(fontSize: 13, color: colr),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              //  flex: 47,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // ignore: unnecessary_null_comparison
                                  if (icon != null)
                                    Icon(
                                      icon,
                                      color: colr,
                                      size: 20.0,
                                    )
                                  else
                                    Text(""),
                                  Text(
                                    "${Utils.getMoneyformat(_resTickerVo.change_price)}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 13, color: colr),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // color: Colors.yellow,
                    width: 120,
                    height: 40,
                    child: Obx(
                      () => chartHomePage(
                          true,
                          CryptoFontIcons.ETH,
                          'Ethereum',
                          'ETH',
                          'USD',
                          [...controller.flSpots],
                          null,
                          controller.yesterdayPrice),
                    ),
                  ),
                  Container(
                    //   padding: EdgeInsets.only(right: 1),
                    child: Icon(
                      Icons.navigate_next_sharp,
                      color: Colors.grey[300],
                      size: 23,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget getSkeleton() {
    const double he = 27.0;
    const double pd = 5.0;
    return Positioned.fill(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              itemCount: 16,
              itemBuilder: (BuildContext context, int index) {
                if (index < 8) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 100 * Random().nextDouble(),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Padding(
                                  padding: const EdgeInsets.all(pd),
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    width: 55,
                                    height: he * 0.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(pd),
                            child: Container(
                              color: Colors.grey.shade300,
                              height: he,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 34,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index > 2)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          width: 45,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          width: 56,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (index > 2)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          width: 67,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          width: 44,
                                          height: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: he,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index > 8 && index < 11)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            width: 35,
                                            height: 6,
                                          ),
                                        ),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            width: 40,
                                            height: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (index > 8 && index < 11)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            width: 34,
                                            height: 6,
                                          ),
                                        ),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            width: 54,
                                            height: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(pd),
                            child: Container(
                              color: Colors.grey.shade300,
                              height: he,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100 * Random().nextDouble(),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Padding(
                                  padding: const EdgeInsets.all(pd),
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    height: he * 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        )
      ]),
    );
  }
}
