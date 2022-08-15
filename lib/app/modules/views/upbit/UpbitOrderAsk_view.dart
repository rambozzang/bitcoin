// ignore: must_be_immutable
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpbitOrderAskView extends StatelessWidget {
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
        //    print("snapshot= ${snapshot.data}");
        if (!snapshot.hasData) {
          return SizedBox(
            height: Get.height * 0.4,
          );
        }
        _resOrderBookVo = snapshot.data!;

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          shrinkWrap: true,
          //  controller: controller.scrollController1,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          itemCount: _resOrderBookVo.orderbook_units?.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 14) {
              controller.isOrderAskCompleted.value = true;
            }
            return getAskRowDetailData(_resOrderBookVo.orderbook_units![index]);
          },
        );
      },
    );
  }

  // 매도세 Ask 리스트
  Widget getAskRowDetailData(ResOrderBookUnitsVo _data) {
    Color clr;
    double sz;

    if (controller.tradePrice == _data.ask_price) {
      clr = Colors.black;
      sz = 1.1;
    } else {
      clr = Colors.white;
      sz = 0.4;
    }

    var containKey = GlobalKey();

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            //  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 1.0),
            padding:
                EdgeInsets.only(top: 3.0, bottom: 3.0, left: 0.0, right: 1.6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Utils.downbgcolor.withOpacity(0.1), // Colors.blue[50],
                border: Border.all(width: sz, color: clr)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 당일 저가 표시
                      controller.getTodayHighPrice == _data.ask_price
                          ? Text("▶",
                              textAlign: TextAlign.start,
                              style: Utils.getTextStyle(_data.ask_persent!, 6))
                          : const SizedBox(
                              width: 1,
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${Utils.getMoneyformat(_data.ask_price)}",
                              textAlign: TextAlign.end,
                              style:
                                  Utils.getTextStyle(_data.ask_persent!, 13)),
                          Text("${_data.ask_persent?.toStringAsFixed(2)}%",
                              textAlign: TextAlign.end,
                              style:
                                  Utils.getTextStyle(_data.ask_persent!, 10)),
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
                key: containKey,
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color:
                        Utils.downbgcolor.withOpacity(0.1), //Colors.blue[50],
                    border: Border.all(width: 0.5, color: Colors.white)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${Utils.getMoneyformat(_data.ask_size).toString()}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: (_data.ask_plus_size ?? 0.0) > 0.0
                          ? Text(
                              " ${Utils.getMoneyformat(_data.ask_plus_size)} ",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Utils.upbgcolor,
                                  fontWeight: FontWeight.normal),
                            )
                          : (_data.ask_minus_size ?? 0.0) > 0.0
                              ? Text(
                                  "-${Utils.getMoneyformat(_data.ask_minus_size)} ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Utils.downbgcolor,
                                      fontWeight: FontWeight.normal),
                                )
                              : const SizedBox(
                                  width: 10,
                                  height: 11,
                                ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 5,
                child: Container(
                  color: Utils.downbgcolor.withOpacity(0.14),
                  width: _data.ask_size_rate!,
                  height: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
