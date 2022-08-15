import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCoinInfoVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class UpbitListView extends GetView<UpBitListController> {
  UpbitListView({Key? key}) : super(key: key);

  // 호가 변경표시를 위한 이전 데이타 저장소
  late List<ResCoinInfoVo> olddata = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(43.0),
          child: AppBar(
            elevation: 0.0,
            titleSpacing: 10,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Transform(
                        transform: new Matrix4.identity()..scale(0.9),
                        child: Chip(
                          backgroundColor: Utils.bgcolor,
                          label: Text("거래소",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.identity()..scale(0.9),
                        child: Chip(
                            backgroundColor: Colors.white,
                            label: Text("NFT",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ))),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.settings_outlined, color: Utils.bgcolor),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.speaker_notes_outlined, color: Utils.bgcolor),
                    ],
                  ),
                )
              ],
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_outlined,
                      color: Utils.bgcolor,
                      size: 21,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Container(
                        height: 16,
                        // color: Colors.yellow,
                        child: TextField(
                          controller: controller.getTextCtrl,
                          cursorColor: Utils.bgcolor,
                          decoration: InputDecoration(
                            // controller.textClear == true
                            suffixIcon:
                                Obx(() => controller.closeBtnDisplay == true
                                    ? IconButton(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        onPressed: () => controller.textClear(),
                                        icon: Icon(
                                          Icons.highlight_off,
                                          size: 20,
                                          color: Utils.bgcolor,
                                        ),
                                      )
                                    : Icon(
                                        Icons.abc,
                                        color: Colors.white,
                                      )),

                            //    : null ),

                            hintText: '코인명/심볼 검색',
                            hintStyle: TextStyle(
                              color: Utils.bgcolor,
                              fontSize: 14.2,
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 0, bottom: 11, top: 0, right: 15),

                            //  labelStyle: TextStyle(color: Colors.redAccent),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(10.0)),
                            //   borderSide:
                            //       BorderSide(width: 1, color: Colors.redAccent),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(10.0)),
                            //   borderSide:
                            //       BorderSide(width: 1, color: Colors.redAccent),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(1.0)),
                            // ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    // Text("코인명/심볼 검색",
                    //     style: TextStyle(
                    //       color: Utils.bgcolor,
                    //       fontSize: 13.2,
                    //       fontWeight: FontWeight.normal,
                    //     ))
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              getTapTradeType(),
              Container(
                height: 1,
                color: Colors.black45,
              ),
              getListTitle(),
              Container(
                height: 1,
                color: Colors.black12,
              ),
              Expanded(
                child: StreamBuilder<dynamic>(
                    stream: controller.streamTiker.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(height: Get.height, width: Get.width);
                      }
                      // 새로 들어온 데이터
                      List<ResCoinInfoVo> data = snapshot.data;
                      if (data == []) {
                        return SizedBox(height: Get.height, width: Get.width);
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          //캔들 높이 구하기
                          double absRate = data[index].yesterday_rate.abs();
                          // 25 : 캔들은 진짜 size height
                          // 30 : 이 수치 보다 높으면 기준을 100 으로 아니면 30을 기준으로
                          double candelHeight = (absRate * 25) /
                              (absRate < 15
                                  ? 15
                                  : absRate < 50
                                      ? 50
                                      : 100);

                          return Column(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  side: BorderSide(
                                      width: 1.0, color: Colors.white30),
                                ),
                                onPressed: () => Get.toNamed('/UpbitMain',
                                    arguments: [
                                      data[index].market.toString(),
                                      data[index].korean_name.toString()
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 25,
                                          color: Colors.grey[200],
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  color: Utils.getTickerColor(
                                                      data[index]
                                                          .yesterday_rate),
                                                  height: candelHeight),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.getisHangul
                                                    ? data[index].korean_name
                                                    : data[index].english_name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                data[index].market.toString() +
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //   Text("(${data[index].english_name.toString()})"),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            // width: Get.width * 0.37,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 1.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              //  color: Colors.black,
                                              border: Border.all(
                                                  width:
                                                      data[index].change_yn ==
                                                              "Y"
                                                          ? 1.5
                                                          : 0,
                                                  color:
                                                      data[index].change_yn ==
                                                              "Y"
                                                          ? Colors.grey
                                                          : Colors.white),
                                            ),
                                            child: Text(
                                              "${Utils.getMoneyformat(data[index].now_price)}",
                                              textAlign: TextAlign.end,
                                              style: Utils.getTextStyle(
                                                  data[index].yesterday_rate,
                                                  11),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            "${data[index].yesterday_rate.toStringAsFixed(2)}%",
                                            textAlign: TextAlign.center,
                                            style: Utils.getTextStyle(
                                                data[index].yesterday_rate, 11),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            controller.getSearchType == "KRW"
                                                ? "${Utils.getMoneyformat(data[index].trade_money)}백만"
                                                : "${Utils.getMoneyformat(data[index].trade_money)}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.black12,
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 탭
  Widget getTapTradeType() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(maxHeight: 35.0, maxWidth: 240),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Material(
                color: Colors.white,
                child: TabBar(
                  // indicatorPadding: EdgeInsets.all(10),
                  labelPadding: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0.0),
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Utils.upbgcolor,
                  controller: controller.tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(
                          width: 1, color: Utils.bgcolor), // Creates border
                      color: Colors.white),
                  tabs: [
                    getTabButton("KRW"),
                    getTabButton("BTC"),
                    getTabButton("USDT"),
                    getTabButton("관심"),
                  ],
                ))),
      ),
    );
  }

  Widget getTabButton(String _title) {
    return Tab(
      child: Text(_title, style: TextStyle(fontSize: 13, color: Utils.bgcolor)),
    );
  }

  // 코인 리스트 제목
  Widget getListTitle() {
    return SizedBox(
      height: 27,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    side: BorderSide(width: 1.0, color: Colors.white30),
                  ),
                  onPressed: () =>
                      controller.setIsHangul(!controller.getisHangul),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('코인명',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // height: 3.0,
                            color: Colors.black87,
                            fontSize: 12.2,
                            fontWeight: FontWeight.normal,
                          )),
                      Icon(
                        Icons.swap_horiz,
                        color: Colors.black87,
                        size: 13,
                      ),
                    ],
                  ),
                )),

            //
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    side: BorderSide(width: 1.0, color: Colors.white30),
                  ),
                  onPressed: () =>
                      controller.setSort("NOW", !controller.getSortDesc),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('현재가',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //    height: 3.0,
                            color: Colors.black87,
                            fontSize: 11.2,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(
                        width: 1,
                      ),
                      Obx(() => Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 20,
                                  color: !controller.getSortDesc &&
                                          controller.getSort == "NOW"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: controller.getSortDesc &&
                                          controller.getSort == "NOW"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    side: BorderSide(width: 1.0, color: Colors.white30),
                  ),
                  onPressed: () =>
                      controller.setSort("RATE", !controller.getSortDesc),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('전일대비',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //    height: 3.0,
                            color: Colors.black87,
                            fontSize: 11.2,
                            fontWeight: FontWeight.normal,
                          )),
                      SizedBox(
                        width: 1,
                      ),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 20,
                                  color: !controller.getSortDesc &&
                                          controller.getSort == "RATE"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: controller.getSortDesc &&
                                          controller.getSort == "RATE"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    side: BorderSide(width: 1.0, color: Colors.white30),
                  ),
                  onPressed: () =>
                      controller.setSort("SIZE", !controller.getSortDesc),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('거래금액',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //    height: 3.0,
                            color: Colors.black87,
                            fontSize: 11.2,
                            fontWeight: FontWeight.normal,
                          )),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 20,
                                  color: !controller.getSortDesc &&
                                          controller.getSort == "SIZE"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: controller.getSortDesc &&
                                          controller.getSort == "SIZE"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                )),
          ]),
    );
  }
}
