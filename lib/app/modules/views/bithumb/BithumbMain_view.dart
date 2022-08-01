import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResOrderBookDepthContent.dart';
import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResOrderBookDepthList.dart';
import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResTickerContent.dart';
import 'package:bitsumb2/app/modules/controllers/bithumb/WebSocketController.dart';
import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResTransactionContent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BithumbkMainView extends GetView<WebSocketController> {
  // 화면에 뿌려줄 총 리스트 갯수
  int viewCount = 18;

//  PubResTicker pubResTicker = new PubResTicker();

  // PubResOrderBookDepth _orderBookDepth = new PubResOrderBookDepth();

  final WebSocketController socketController = Get.put(WebSocketController());

  late PubResTickerContent _pubResTickerContent = new PubResTickerContent();
  late PubResOrderBookDepthContent _pubResOrderBookDepthContent =
      new PubResOrderBookDepthContent();
  late PubResTransactionContent _pubResTransactionContent =
      new PubResTransactionContent();

//  final socketIO = Get.find<SocketController>();

  @override
  Widget build(BuildContext context) {
    print("====== StockMain_view.dart build 실행!!");

    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stock Main',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: StreamBuilder<dynamic>(
                  stream: socketController.socket!.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var _data = json.decode(snapshot.data);
                      print("aaa= ${_data}");

                      print("bbb= ${_data["content"]}");

                      if (_data["type"].toString() == "ticker") {
                        _pubResTickerContent =
                            PubResTickerContent.fromMap(_data["content"]);
                      } else if (_data["type"].toString() == "orderbookdepth") {
                        _pubResOrderBookDepthContent =
                            PubResOrderBookDepthContent.fromMap(
                                _data["content"]);
                      } else if (_data["type"].toString() == "transaction") {
                        _pubResTransactionContent =
                            PubResTransactionContent.fromMap(_data["content"]);
                      } else {
                        return Container(
                          child: OutlinedButton(
                              onPressed: () {
                                //  socketController.sendTicker();
                                socketController.sendOrderBook();
                                //  socketController.sendTransaction();
                              },
                              child: Text("Send")),
                        );
                      }

                      print(_data);
                      return getMainList(
                          _pubResTickerContent,
                          _pubResOrderBookDepthContent,
                          _pubResTransactionContent);
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  // 상단 메인
  Widget getMainList(
      PubResTickerContent? _pubResTickerContent,
      PubResOrderBookDepthContent? _pubResOrderBookDepthContent,
      PubResTransactionContent? _PubResTransactionContent) {
    return getCenterList(_pubResOrderBookDepthContent!);
    // return Container(
    //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    // 왼쪽
    // getLeftList(_data),
    // 가운데
    //  getCenterList(_pubResOrderBookDepthContent!),
    // 오른쪽
    //  getRightList()
    //    ]),
    //);
  }

  Widget getCenterList(PubResOrderBookDepthContent _data) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        //   controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        itemCount: _data.list?.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          // print(_list.elementAt(index)["mainYn"]);

          return getRowData(_data.list![index]);
        });
  }

  Widget getRowData(PubResOrderBookDepthList _data) {
    // 등락율로 판단하여 숫자 색상 결정
    Color colr = _data.orderType == "ask" ? Colors.red : Colors.blue;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: Get.width * 0.37,
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 1.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Colors.blue[100],
                border: Border.all(width: 0.4, color: Colors.grey.shade400)),
            child: Text(
              _data.orderType == "ask" ? _data.quantity ?? "" : "",
              textAlign: TextAlign.end,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: Get.width * 0.37,
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 1.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                //     color: Colors.red[100],
                border: Border.all(width: 0.4, color: Colors.grey.shade400)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    " ",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${_data.price}",
                    style: TextStyle(
                        fontSize: 14,
                        color: colr,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${_data.price?.replaceAll("-", "")}%",
                    style: TextStyle(
                        fontSize: 10,
                        color: colr,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              width: Get.width * 0.37,
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 1.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: Colors.red[100],
                  border: Border.all(width: 0.4, color: Colors.grey.shade400)),
              child: Text(_data.orderType != "ask" ? _data.quantity ?? "" : ""),
            ))
      ],
    );
  }

  Widget getLeftList(PubResTickerContent _data) {
    // 현재가 closePrice 로 판단하여 매도 호가를 보여주거나 실거래내역을 판단.

    return Container(
      child: Column(
        children: [
          Text("${_data.sellVolume}"),
        ],
      ),
    );
  }

  Widget getRightList() {
    return Container(
      child: Text("aaa"),
    );
  }
}
