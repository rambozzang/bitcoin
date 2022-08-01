import 'dart:async';

import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitOrderAsk_view.dart';
import 'package:bitsumb2/app/modules/views/upbit/upbitOrderBid_view.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class UpbitOrderView extends StatelessWidget {
  final UpbitMainController controller = Get.find<UpbitMainController>();

  RadioGroupController myController = RadioGroupController();

  //금액 포멧
  var f = NumberFormat('###,###,###,###');
  var f2 = NumberFormat('###,###,###,###.00#');

  // 코인은 자릿수
  int coinNum = 2;

  Rx<bool> isLoading = false.obs;

  void scrollCenter() async {
    if (controller.isOrderAskCompleted == true &&
        controller.isOrderBidCompleted == true) {
      // await controller.scrollOrderController.animateTo(
      //   controller.scrollOrderController.position.maxScrollExtent * 0.53,
      //   curve: Curves.easeOut,
      //   duration: const Duration(milliseconds: 100),
      // );
      controller.scrollOrderController.jumpTo(
          controller.scrollOrderController.position.maxScrollExtent * 0.53);

      // 로딩완료 상태 변경
      isLoading.value = true;

      // 상단 미니 캔들 데이터 가져오기
      controller.getCandleFlSpotByUpbit();
    } else {
      Timer(Duration(milliseconds: 100), () => scrollCenter());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollCenter());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: getMainList(),
    );
  }

  // 상단 메인
  Widget getMainList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollOrderController,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          //  getAskList(),
                          UpbitOrderAskView(),
                          Container(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          //  getBidList(),
                          UpbitOrderBidView()
                        ],
                      ),
                    ),
                  ),
                  getOrderForm(),
                ],
              ),
              Obx(
                () => !isLoading.value ? getSkeleton() : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getOrderForm() {
    return Container(
      width: Get.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        children: [
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTapTradeType(),
                const SizedBox(
                  height: 6,
                ),
                RadioGroup(
                  controller: myController,
                  values: ["지정", "시장", "예약"],
                  indexOfDefault: 0,
                  orientation: RadioGroupOrientation.Horizontal,
                  decoration: RadioGroupDecoration(
                    spacing: 0.0,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    activeColor: Colors.blueAccent,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  //  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  height: 35.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "주문가능",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "100 ",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "=0 KRW ",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1),
                  height: 32.0,
                  child: Row(
                    children: [
                      //  Text("a"), Text("asdf")
                      Expanded(
                        flex: 60,
                        child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.redAccent,
                              primaryColorDark: Colors.red,
                            ),
                            child: new TextField(
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: '수량',
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    textBaseline: TextBaseline.ideographic),
                              ),
                            )),
                      ),
                      Expanded(
                          flex: 40,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                                color: Colors.grey[300],
                                height: 35.0,
                                child: Center(
                                    child: const Text(
                                  "최대",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ))),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1),
                  height: 33.0,
                  child: Row(
                    children: [
                      //  Text("a"), Text("asdf")
                      Expanded(
                        flex: 60,
                        child: new Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: new TextField(
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal),
                                  gapPadding: 0),
                              hintText: '가격',
                              hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  textBaseline: TextBaseline.ideographic),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 40,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                                color: Colors.grey[300],
                                height: 35.0,
                                child: Center(
                                    child: const Text(
                                  "최대",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ))),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1),
                  height: 33.0,
                  child: Row(
                    children: [
                      //  Text("a"), Text("asdf")
                      Expanded(
                        flex: 60,
                        child: Container(
                          color: Colors.grey[300],
                          height: 35.0,
                          child: Center(
                              child: const Text(
                            "현재가대비%",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )),
                        ),
                      ),
                      Expanded(flex: 40, child: const Text(" "))
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1),
                  height: 33.0,
                  child: Row(
                    children: [
                      //  Text("a"), Text("asdf")
                      Expanded(
                        flex: 1,
                        child: new Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: new TextField(
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              hintText: '총액',
                              hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  textBaseline: TextBaseline.ideographic),
                              //  helperText: '2.',
                              //  labelText: '총액',
                              // prefixText: ' ',
                              // suffixText: '0',
                              // suffixStyle:
                              //     const TextStyle(color: Colors.green)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                getOrderbtn(),
                getOrderbtnunderText()
              ],
            ),
          ),
          getOrderUnderBtn()
        ],
      ),
    );
  }

  Widget getOrderbtnunderText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "최소주문금액",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              "5,000KRW",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "수수료",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              "0.05%",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "주문유형안내",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              " ",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  Widget getOrderbtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              height: 35.0,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {},
                  child: Text(
                    '초기화',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              height: 35.0,
              //  color: Colors.red,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
                child: Text(
                  '매수',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getOrderUnderBtn() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          height: 35.0,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              side: BorderSide(width: 1.0, color: Colors.black),
            ),
            onPressed: null,
            child: Text(
              "현재가 전액매도",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          height: 35.0,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              side: BorderSide(width: 1.0, color: Colors.black),
            ),
            onPressed: null,
            child: Text(
              "호가 주문",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // 탭
  Widget getTapTradeType() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(maxHeight: 35.0),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(0.0),
            color: Colors.white,
            // border: Border.all(width: 0, color: Colors.grey.shade300),
          ),
          child: Material(
              color: Colors.grey[200],
              child: TabBar(
                // indicatorPadding: EdgeInsets.all(10),
                labelPadding: EdgeInsets.all(0),

                padding: EdgeInsets.all(0.0),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                labelColor: Utils.upbgcolor,
                controller: controller.tabOrderController,
                indicator: BoxDecoration(
                    //  borderRadius: BorderRadius.circular(0),
                    // border: Border.all(
                    //     width: 0.1, color: Utils.bgcolor), // Creates border
                    color: Colors.white),
                tabs: [
                  getTabButton("매수"),
                  getTabButton("매도"),
                  getTabButton("거래내역"),
                ],
              ))),
    );
  }

  Widget getTabButton(String _title) {
    late var cl = Colors.black;
    if (_title == "매수") {
      cl = Colors.red;
      print("매수");
    } else if (_title == "매도") {
      cl = Colors.blueAccent;
    } else if (_title == "거래내약") {
      cl = Colors.black;
    }
    return Tab(
      child: Container(
          //   color: cl,
          child: Text(_title, style: TextStyle(fontSize: 12, color: cl))),
    );
  }

  // 스케렌토
  Widget getSkeleton() {
    // return Container(
    //   color: Colors.grey[50],
    // );
    return Container(
      color: Colors.grey[50],
      child: Center(
          child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Utils.upbgcolor,
        ),
      )),
    );
  }

  // 스케렌토
  Widget getSkeleton1() {
    return Positioned.fill(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: Container(
              color: Colors.white,
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  itemCount: 16,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: Get.width * 0.4,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                color: Colors.grey.shade300,
                                width: 55,
                                height: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  })))
    ]));
  }
}
