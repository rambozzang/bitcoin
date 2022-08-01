import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTradeVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class UpbitTradeView extends StatelessWidget {
  //체결 리스트vo
  final UpbitMainController controller = Get.find<UpbitMainController>();

  int tradeListLimit = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: getMainList());
  }

  // 상단 메인
  Widget getMainList() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: BouncingScrollPhysics(),
            child: getTradeList(),
          ),
        ),
      ],
    );
  }

  // 매수 실거래내역
  Widget getTradeList() {
    //  socketController.tradeForce
    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          height: 1,
        ),
        getTapTradeType(),
        StreamBuilder<dynamic>(
          stream: controller.streamTradeForce.stream,
          //  initialData: "100",
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            var _data = snapshot.data;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "체결강도 :",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${_data.toString()}%",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                )
              ],
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 14.0),
          child: StreamBuilder<dynamic>(
              stream: controller.streamTrade.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                //체결 리스트vo
                List<ResTradeVo> _listResTradeVo = snapshot.data;

                var _len = controller.listResTradeVo.length;
                return Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    Container(
                      height: 31,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "체결시간",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "체결가격(KRW)",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "체결량",
                            style: TextStyle(
                              fontSize: 14,
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
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        itemCount: _len,
                        itemBuilder: (BuildContext context, int index) {
                          var idx = _len - index - 1;
                          return Column(
                            children: [
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _listResTradeVo[idx]
                                            .trade_time
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _listResTradeVo[idx]
                                                        .trade_price! <
                                                    controller.yPrice
                                                ? Utils.downbgcolor
                                                : Utils.upbgcolor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        // _listResTradeVo[idx].trade_price.toString(),
                                        Utils.getMoneyformat(
                                                _listResTradeVo[idx]
                                                    .trade_price)
                                            .toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _listResTradeVo[idx]
                                                        .trade_price! <
                                                    controller.yPrice
                                                ? Utils.downbgcolor
                                                : Utils.upbgcolor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        Utils.getMoneyformat(
                                            _listResTradeVo[idx].trade_volume),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                _listResTradeVo[idx].ask_bid ==
                                                        "ASK"
                                                    ? Utils.downbgcolor
                                                    : Utils.upbgcolor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey[300],
                                height: 1,
                              ),
                            ],
                          );
                        }),
                  ],
                );
              }),
        ),
      ],
    );
  }

  // 탭
  Widget getTapTradeType() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(maxHeight: 31.0, maxWidth: 120),
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
                  controller: controller.tabTradeController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(
                          width: 1, color: Utils.bgcolor), // Creates border
                      color: Colors.white),
                  tabs: [
                    getTabButton("체결"),
                    getTabButton("일별"),
                  ],
                ))),
      ),
    );
  }

  Widget getTabButton(String _title) {
    return Tab(
      child: Text(_title, style: TextStyle(fontSize: 11, color: Utils.bgcolor)),
    );
  }
}
