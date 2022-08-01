import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTradeVo.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTikerAsk_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitTikerBid_view.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class UpbitTikerView extends StatelessWidget {
  final UpbitMainController controller = Get.find<UpbitMainController>();

  TextStyle _text1 = TextStyle(
      fontSize: 11, color: Colors.black, fontWeight: FontWeight.normal);

  TextStyle _text1blue = TextStyle(
      fontSize: 11, color: Utils.downbgcolor, fontWeight: FontWeight.normal);

  TextStyle _text1red = TextStyle(
      fontSize: 11, color: Utils.upbgcolor, fontWeight: FontWeight.normal);

  TextStyle _text2 =
      TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.normal);

  //금액 포멧
  var f = NumberFormat('###,###,###,###');
  var f2 = NumberFormat('###,###,###,###.00#');

  // 코인은 자릿수
  int coinNum = 2;

  final List<Tab> tabs = [
    Tab(height: 50, child: Text("주문")),
    Tab(height: 50, child: Text("호가")),
    Tab(height: 50, child: Text("차트")),
    Tab(height: 50, child: Text("시세")),
    Tab(height: 50, child: Text("정보")),
  ];

  // animation Text 처리

  void scrollCenter() async {
    // if (controller.scrollController2.hasClients &&
    //     controller.scrollController1.hasClients) {
    if (controller.isTikerAskCompleted == true &&
        controller.isTikerBidCompleted == true) {
      // await controller.scrollController.animateTo(
      //   controller.scrollController.position.maxScrollExtent * 0.53,
      //   curve: Curves.easeOut,
      //   duration: const Duration(milliseconds: 100),
      // );
      controller.scrollTikerController.jumpTo(
          controller.scrollTikerController.position.maxScrollExtent * 0.53);
      //  controller.setEnabled();
      // Timer(Duration(milliseconds: 10), () {
      //   controller.setEnabled();
      // });

      // controller.scrollController
      //     .jumpTo(controller.scrollController.position.maxScrollExtent * 0.53);
    } else {
      Timer(Duration(milliseconds: 100), () => scrollCenter());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("UpbitTikerView build ~!");
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollCenter());
    return Scaffold(
      backgroundColor: Colors.white,
      body: getMainList(),
    );
  }

  // 상단 메인
  Widget getMainList() {
    return Stack(
      children: [
        Column(
          children: [
            //   getTop(),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollTikerController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [UpbitTikerAskView(), getInfoDesk()],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTradeList(),
                        UpbtitTikerBidView()
                        // getBidList(),
                      ],
                    ), // 매수 호가
                  ],
                ),
              ),
            ),
            getBottom()
          ],
        ),
        // GetX<UpbitTikerController>(builder: (_) {
        //   if (_.enabled.value) {
        //     return getSkeleton();
        //   } else {
        //     return const SizedBox.shrink();
        //   }
        // }),
      ],
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
    return Column(
      children: [
        StreamBuilder<dynamic>(
            stream: controller.streamTiker.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              ResTickerVo _data = snapshot.data;
              Color colr = Colors.red;
              late IconData icon;
              if (_data.change == "RISE") {
                colr = Colors.red;
                icon = Icons.arrow_drop_up;
              } else if (_data.change == "EVEN") {
                colr = Colors.black;
                icon = Icons.arrow_drop_up;
              } else if (_data.change == "FALL") {
                colr = Colors.blue;
                icon = Icons.arrow_drop_down;
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
                                "${Utils.getMoneyformat(_data.trade_price)}",
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
                                "${(_data.signed_change_rate! * 100).toStringAsFixed(2)}%",
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
                                    icon != null
                                        ? Icon(
                                            icon,
                                            color: colr,
                                            size: 20.0,
                                          )
                                        : Text(""),
                                    Text(
                                      "${Utils.getMoneyformat(_data.change_price)}",
                                      textAlign: TextAlign.start,
                                      style:
                                          TextStyle(fontSize: 13, color: colr),
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
      ],
    );
  }

  // 하단 누적 수량
  Widget getBottom() {
    return StreamBuilder<ResOrderBookVo>(
        stream: controller.streamOrderBook.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 35,
            );
          }
          ResOrderBookVo _data = snapshot.data!;

          //체결강도
          controller.streamTradeForce.sink.add(
              ((_data.total_ask_size! / _data.total_bid_size!) * 100)
                  .toStringAsFixed(2));

          return Container(
            height: 35,
            color: Colors.white60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "${this.f2.format(_data.total_ask_size)}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "수량(${_data.code})",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${this.f2.format(_data.total_bid_size)}",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // 매도세 우측 데스크 정보
  Widget getInfoDesk() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<dynamic>(
            stream: controller.streamTiker.stream,
            builder: (context, snapshot) {
              // print("snapshot= ${snapshot.data}");
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }

              ResTickerVo _data = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "거래량",
                        style: _text1,
                      ),
                      Text(
                        "${Utils.getMoneyformat(_data.acc_trade_volume_24h)}",
                        style: _text1,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "거래금",
                        style: _text1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.acc_trade_price_24h! / 1000 / 1000)}백만원",
                            style: _text1,
                          ),
                          Text(
                            "(최근 24시간)",
                            style: _text2,
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "52주최고",
                        style: _text1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.highest_52_week_price)}",
                            style: _text1red,
                          ),
                          Text(
                            "(${_data.highest_52_week_date})",
                            style: _text2,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "52주최저",
                        style: _text1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.lowest_52_week_price)}",
                            style: _text1blue,
                          ),
                          Text(
                            "(${_data.lowest_52_week_date})",
                            style: _text2,
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "전일종가",
                        style: _text1,
                      ),
                      Text(
                        "${Utils.getMoneyformat(_data.prev_closing_price)}",
                        style: _text1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "당일고가",
                        style: _text1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.high_price)}",
                            style: _text1red,
                          ),
                          Text(
                            "${(((_data.high_price! / _data.prev_closing_price!) * 100) - 100).toStringAsFixed(2)}%",
                            style: _text1red,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "당일저가",
                        style: _text1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.low_price)}",
                            style: _text1blue,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            //  prev_closing_price
                            "${((((_data.low_price! / _data.prev_closing_price!) * 100) - 100).toStringAsFixed(2))}%",
                            style: _text1blue,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }

  // 매수 실거래내역
  Widget getTradeList() {
    //  socketController.tradeForce
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            color: Colors.grey[200],
            height: 1,
          ),
          StreamBuilder<dynamic>(
            stream: controller.streamTradeForce.stream,
            //  initialData: "100",
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              var _data = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "체결강도",
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${_data.toString()}%",
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  )
                ],
              );
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
            child: StreamBuilder<dynamic>(
                stream: controller.streamTrade.stream,
                builder: (context, snapshot) {
                  // print("snapshot= ${snapshot.data}");
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  //체결 리스트vo
                  List<ResTradeVo> _listResTradeVo = snapshot.data;

                  var _len = controller.listResTradeVo.length;
                  return Column(
                    children: [
                      Container(
                        height: 18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "체결가",
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "체결량",
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        height: 1,
                      ),
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          //   controller: _scrollController,
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          itemCount: _len,
                          itemBuilder: (BuildContext context, int index) {
                            var idx = _len - index - 1;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // _listResTradeVo[idx].trade_price.toString(),
                                  Utils.getMoneyformat(
                                          _listResTradeVo[idx].trade_price)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _listResTradeVo[idx].trade_price! <
                                              controller.yPrice
                                          ? Colors.blue
                                          : Colors.red,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  Utils.getMoneyformat(
                                      _listResTradeVo[idx].trade_volume),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          _listResTradeVo[idx].ask_bid == "ASK"
                                              ? Colors.blue
                                              : Colors.red,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            );
                          }),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget getSk() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              color: Colors.grey.shade300,
              width: double.infinity,
              height: 30,
            ),
          ],
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          height: 40,
        ),
        SizedBox(
          height: 5,
        ),
      ],
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
