import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpbtitTikerBidView extends StatelessWidget {
  UpbtitTikerBidView({Key? key}) : super(key: key);

  final UpbitMainController controller = Get.find<UpbitMainController>();

  late ResOrderBookVo _resOrderBookVo = new ResOrderBookVo();

  //금액 포멧
  var f = NumberFormat('###,###,###,###');
  var f2 = NumberFormat('###,###,###,###.00#');

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: StreamBuilder<ResOrderBookVo>(
            stream: controller.streamOrderBook.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: Get.height * 0.4,
                );
              }
              _resOrderBookVo = snapshot.data!;

              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //   controller: controller.scrollController2,
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  itemCount: _resOrderBookVo.orderbook_units?.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 14) {
                      controller.setTikerBidCompleted(true);
                    }
                    return getBidRowDetailData(
                        _resOrderBookVo.orderbook_units![index]);
                  });
            }));
  }

  // 매수세 Bid 리스트
  Widget getBidRowDetailData(ResOrderBookUnitsVo _data) {
    // 어제종가로 등락율% 구하기
    // var pers = (((_data.bid_price! / controller.yesterdayPrice) * 100) - 100)
    //     .toStringAsFixed(2);
    // // error 처리
    // pers = (pers == "Infinity")
    //     ? (((_data.bid_price! / _data.ask_price!) * 100) - 100)
    //         .toStringAsFixed(2)
    //     : pers;

    Color clr;
    double sz;
    // double tradePrice = 0.0;

    // if (controller.listResTradeVo.length != 0) {
    //   tradePrice = controller.listResTradeVo.reversed.first.trade_price ?? 0.0;
    // }

    if (controller.tradePrice == _data.bid_price) {
      clr = Colors.black;
      sz = 1.1;
    } else {
      clr = Colors.white;
      sz = 0.4;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(top: 9, bottom: 9, left: 0, right: 1.0),
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: Utils.upbgcolor.withOpacity(0.1), // Colors.red[50],
              border: Border.all(width: sz, color: clr),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 당일 저가 표시
                      controller.getTodayLowPrice == _data.bid_price
                          ? Text(
                              "▶",
                              textAlign: TextAlign.start,
                              style: Utils.getTextStyle(_data.bid_persent!, 10),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      Text(
                        "${Utils.getMoneyformat(_data.bid_price)}",
                        textAlign: TextAlign.end,
                        style: Utils.getTextStyle(_data.bid_persent!, 13),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${_data.bid_persent!.toStringAsFixed(2)}%",
                    textAlign: TextAlign.end,
                    style: Utils.getTextStyle(_data.bid_persent!, 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  height: 38,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color:
                          Utils.upbgcolor.withOpacity(0.1), // Colors.red[50],
                      border: Border.all(width: 0.4, color: Colors.white)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Utils.getMoneyformat(_data.bid_size).toString()}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      (_data.bid_plus_size ?? 0.0) > 0.0
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                " ${Utils.getMoneyformat(_data.bid_plus_size)} ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Utils.upbgcolor,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : (_data.bid_minus_size ?? 0.0) > 0.0
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "-${Utils.getMoneyformat(_data.bid_minus_size)}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Utils.downbgcolor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              : const SizedBox(
                                  width: 10,
                                  height: 11,
                                ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 5,
                  child: Container(
                    color: Utils.upbgcolor.withOpacity(0.14),
                    width: _data.bid_size_rate,
                    height: 17,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
