import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqBodyVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqTicketVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonce/nonce.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<ResTickerVo> parseResTickerVo(dynamic data) async {
  Uint8List bytes = Uint8List.fromList(data);
  String _byteStr = String.fromCharCodes(bytes);

  var _data = json.decode(_byteStr);
  return ResTickerVo.fromMap(_data);
}

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitMainTabbarController extends GetxController
    // ignore: deprecated_member_use
    with
        GetSingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late TabController tabController;
  void changeRootPageIndex(int index) {
    pageIndex(index);
  }

// tiker 멀티 listen 을 위해 brodcat 처리
  StreamController<ResTickerVo> streamTiker = new StreamController();

  late WebSocketChannel _channelTicker;

  // 화면 최초 로딩 완료여부
  RxBool initdata = false.obs;

  // get.toName 으로 넘어온 코인코드,명
  var coinCode = "";
  var coinName = "";

  WebSocketChannel get socketTicker => this._channelTicker;

  //웹소켓으로 가져올 코인 리스트
  var _coinlist = new List<String>.empty(growable: true);
  //웹소켓으로 가져올 요청맵
  var _req = new List.empty(growable: true);

  //전일종가
  double yesterdayPrice = 0.0;
  double get yPrice => this.yesterdayPrice;

  //당일고가
  double todayHighPrice = 0.0;
  double get getTodayHighPrice => this.todayHighPrice;

  //당일저가
  double todayLowPrice = 0.0;
  double get getTodayLowPrice => this.todayLowPrice;

  //체결강도
  String tradeForce = "0";
  String get getTradeForce => this.tradeForce;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 5);

    print("UpbitMainController onInit() 실행!!");

    _channelTicker = IOWebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
        pingInterval: Duration(seconds: 3));

    //현재가 ticker  2개의 widget 에 데이터를 넘겨주기위해 brodcast 으로 처리.
    _channelTicker.stream.listen((data) async {
      Uint8List bytes = Uint8List.fromList(data);
      String _byteStr = String.fromCharCodes(bytes);
      ResTickerVo _data = ResTickerVo.fromMap(json.decode(_byteStr));

      // ResTickerVo _data = await compute(parseResTickerVo, data);
      //어제 종가 셋팅
      yesterdayPrice = _data.prev_closing_price ?? 0.0;
      //당일고가
      todayHighPrice = _data.high_price ?? 0.0;
      //당일저가
      todayLowPrice = _data.low_price ?? 0.0;

      if (!streamTiker.isClosed) {
        streamTiker.sink.add(_data);
      }
    });

    //ar value = Get.arguments;
    coinCode = Get.arguments[0];
    coinName = Get.arguments[1];
    ;
    this.send("orderbook", coinCode);
    this.send("trade", coinCode);
    this.send("ticker", coinCode);

    super.onInit();
  }

  void send(String _type, String _coin) {
    // 변수 초기화
    _coinlist.clear();
    _req.clear();

    // 1.티켓 추가
    ReqTicketVo _ticket = new ReqTicketVo();
    _ticket.ticket = Nonce.generate();

    // 2.코인 추가
    _coinlist.add(_coin);

    // 3.바디(요청종목 + 코인리스트) 생성
    ReqBodyVo _reqBodyVo = new ReqBodyVo();
    _reqBodyVo.type = _type;
    _reqBodyVo.codes = _coinlist;

    // 4.최종 리트 생성 티켓 + 바디
    _req.add(_ticket.toJson());
    _req.add(_reqBodyVo.toJson());

    // print("_req 1: ${_req.toString()}");
    _channelTicker.sink.add(_req.toString());
  }

  @override
  void onClose() {
    print("dispose!!!!!! ");
    streamTiker.close();
    scrollController.dispose();
    _channelTicker.sink.close(status.goingAway);

    super.dispose();
  }
}
