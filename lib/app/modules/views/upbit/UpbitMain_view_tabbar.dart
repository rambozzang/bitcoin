import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitChart_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitList_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitOrder_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTicker_Binding.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitTrade_Binding.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController_tabbar.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitTikerController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTradeVo.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitChart_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitList_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitOrder_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTiker_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTrade_view.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpbitMainView2 extends GetView<UpbitMainTabbarController> {
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

  final List<dynamic> tabviews = [
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
      //      key: controller.navigatorKey,
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

  void scrollCenter() async {
    if (controller.scrollController.hasClients) {
      await controller.scrollController.animateTo(
        //  350.0,
        Get.height * 0.4,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 600),
      );
    } else {
      Timer(Duration(milliseconds: 500), () => scrollCenter());
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance?.addPostFrameCallback((_) => scrollCenter());
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
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    Icon(Icons.star_border_outlined, color: Utils.bgcolor),
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
        body: getMainList());
  }

  // 상단 메인
  Widget getMainList() {
    return Column(
      children: [
        getTop(),
        getAnimatedText(),
        Container(
            constraints: BoxConstraints(maxHeight: 41.0),
            child: Material(
                color: Utils.bgcolor,
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  controller: controller.tabController,
                  tabs: tabs,
                ))),
        Expanded(
          child: getBody(),
        ),
      ],
    );
  }

  Widget getBody() {
    return TabBarView(
      controller: controller.tabController,
      children: tabviews.map((dynamic tab) {
        return Center(
          child: tab,
        );
      }).toList(),
    );
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
                height: Get.height * 0.1,
              );
            }
            _resTickerVo = snapshot.data!;

            Color colr = Colors.red;

            late IconData icon;
            if (_resTickerVo.change == "RISE") {
              colr = Colors.red;
              icon = Icons.arrow_drop_up;
            } else if (_resTickerVo.change == "EVEN") {
              colr = Colors.black;
              icon = Icons.arrow_drop_up;
            } else if (_resTickerVo.change == "FALL") {
              colr = Colors.blue;
              icon = Icons.arrow_drop_down;
            } else {
              colr = Colors.blue;
            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
}
