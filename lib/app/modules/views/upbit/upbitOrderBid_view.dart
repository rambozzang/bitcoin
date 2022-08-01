// ignore: must_be_immutable
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpbitOrderBidView extends StatelessWidget {
  final controller = Get.find<UpbitMainController>();
  late ResOrderBookVo _resOrderBookVo = new ResOrderBookVo();

  //금액 포멧
  var f = NumberFormat('###,###,###,###');
  var f2 = NumberFormat('###,###,###,###.00#');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResOrderBookVo>(
        stream: controller.streamOrderBook.stream,
        builder: (context, snapshot) {
          // print("snapshot= ${snapshot.data}");
          if (!snapshot.hasData) {
            return SizedBox(
              height: Get.height * 0.4,
            );
          }
          _resOrderBookVo = snapshot.data!;
          int? cnt = _resOrderBookVo.orderbook_units?.length;

          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              //controller: controller.scrollController2,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              itemCount: cnt,
              itemBuilder: (BuildContext context, int index) {
                if (index == 14) {
                  controller.isOrderBidCompleted.value = true;
                }
                return getBidRowDetailData(
                    _resOrderBookVo.orderbook_units![index]);
              });
        });
  }

  // 매수세 Bid 리스트
  Widget getBidRowDetailData(ResOrderBookUnitsVo _data) {
    Color clr;
    double sz;
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
            padding: EdgeInsets.only(top: 3, bottom: 3, left: 0, right: 1.6),
            height: 40,
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
                              style: Utils.getTextStyle(_data.bid_persent!, 6),
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Utils.getMoneyformat(_data.bid_price)}",
                            textAlign: TextAlign.end,
                            style: Utils.getTextStyle(_data.bid_persent!, 13),
                          ),
                          Text(
                            "${_data.bid_persent?.toStringAsFixed(2)}%",
                            textAlign: TextAlign.end,
                            style: Utils.getTextStyle(_data.bid_persent!, 10),
                          ),
                        ],
                      ),
                    ],
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
                  height: 40,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color:
                          Utils.upbgcolor.withOpacity(0.1), // Colors.red[50],
                      border: Border.all(width: 0.4, color: Colors.white)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${this.f2.format(_data.bid_size).toString()}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      (_data.bid_plus_size ?? 0.0) > 0.0
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                " ${this.f2.format(_data.bid_plus_size)} ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Utils.upbgcolor,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : (_data.bid_minus_size ?? 0.0) > 0.0
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "-${this.f2.format(_data.bid_minus_size)}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10,
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
                  right: 0,
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
