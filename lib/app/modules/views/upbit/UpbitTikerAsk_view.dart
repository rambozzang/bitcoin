import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpbitTikerAskView extends StatelessWidget {
  UpbitTikerAskView({Key? key}) : super(key: key);

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
          // print("snapshot= ${snapshot.data}");
          if (!snapshot.hasData) {
            return SizedBox(
              height: Get.height * 0.4,
            );
          }

          _resOrderBookVo = snapshot.data!;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            //  controller: controller.scrollController1,
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            itemCount: _resOrderBookVo.orderbook_units?.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 14) {
                controller.setTikerAskCompleted(true);
              }
              return getAskRowDetailData(
                  _resOrderBookVo.orderbook_units![index]);
            },
          );
        },
      ),
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
          child: Stack(
            children: [
              Container(
                key: containKey,
                height: 38,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
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
                      "${this.f2.format(_data.ask_size).toString()}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    (_data.ask_plus_size ?? 0.0) > 0.0
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " ${this.f2.format(_data.ask_plus_size)} ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : (_data.ask_minus_size ?? 0.0) > 0.0
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "-${this.f2.format(_data.ask_minus_size)} ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.blue,
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
                  color: Utils.downbgcolor.withOpacity(0.14),
                  width: _data.ask_size_rate!,
                  height: 17,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 38,
            //  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 1.0),
            padding: const EdgeInsets.only(
                top: 9.0, bottom: 9.0, left: 1.0, right: 0.0),
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
                          ? Text(
                              "▶",
                              textAlign: TextAlign.start,
                              style: Utils.getTextStyle(_data.ask_persent!, 10),
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                      Text(
                        "${Utils.getMoneyformat(_data.ask_price)}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 13,
                            color: _data.ask_persent! > 0.0
                                ? Utils.upbgcolor
                                : _data.ask_persent == 0.0
                                    ? Colors.black
                                    : Utils.downbgcolor,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                // 전일종가 대비 등락율 계산
                Expanded(
                  flex: 1,
                  child: Text(
                    "${_data.ask_persent!.toStringAsFixed(2)}%",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 10,
                        color: _data.ask_persent! > 0.0
                            ? Utils.upbgcolor
                            : _data.ask_persent == 0.0
                                ? Colors.black
                                : Utils.downbgcolor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
