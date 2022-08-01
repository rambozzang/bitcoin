import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqBodyVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqTicketVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTradeVo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonce/nonce.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<ResOrderBookVo> parseResOrderBookVo(dynamic data) async {
  Uint8List bytes = Uint8List.fromList(data);
  String _byteStr = String.fromCharCodes(bytes);
  var _data = json.decode(_byteStr);
  return ResOrderBookVo.fromMap(_data);
}

Future<ResTickerVo> parseResTickerVo(dynamic data) async {
  Uint8List bytes = Uint8List.fromList(data);
  String _byteStr = String.fromCharCodes(bytes);

  var _data = json.decode(_byteStr);
  return ResTickerVo.fromMap(_data);
}

Future<ResTradeVo> parseResTradeVo(dynamic data) async {
  Uint8List bytes = Uint8List.fromList(data);
  String _byteStr = String.fromCharCodes(bytes);
  var _data = json.decode(_byteStr);
  return ResTradeVo.fromMap(_data);
}

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitTikerController extends GetxController
    // ignore: deprecated_member_use
    with
        GetSingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;

  late WebSocketChannel _channelOrderbook;

  // orderBook 멀티 listen 을 위해 brodcat 처리
  StreamController<ResOrderBookVo> streamOrderBook =
      new StreamController.broadcast();

// tiker 멀티 listen 을 위해 brodcat 처리
  StreamController<ResTickerVo> streamTiker = new StreamController.broadcast();
  StreamController<String> streamTradeForce = new StreamController();
  StreamController<List<ResTradeVo>> streamTrade = new StreamController();

  late WebSocketChannel _channelTrade;
  late WebSocketChannel _channelTicker;

  // 화면 최초 로딩 완료여부
  RxBool isCompleteDisplay = false.obs;

//체결 리스트vo
  late List<ResTradeVo> listResTradeVo = [];
  int tradeListLimit = 25;

  // get.toName 으로 넘어온 코인코드,명
  var coinCode = "";
  var coinName = "";

  WebSocketChannel get socketOrderbook => this._channelOrderbook;
  WebSocketChannel get socketTrade => this._channelTrade;
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

  //현재 거가
  double tradePrice = 1.0;

  var enabled = true.obs;
  void setEnabled() {
    this.enabled.value = false;
    //update();
  }

  // 메인 스크롤 및 매수,매도 호가 리스트 스크롤 컨트롤러
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  // 호가 listview 그리기 완성여부
  var isAskCompleted = false.obs;
  var isBidCompleted = false.obs;

  void setAskCompleted(bool _b) {
    isAskCompleted.value = _b;
    //isCompleteDisplay.value = isBidCompleted.value ? true : false;
    if (isAskCompleted.value && isBidCompleted.value) {
      isCompleteDisplay.value = true;
      //   update();
    }
  }

  void setBidCompleted(bool _b) {
    isBidCompleted.value = _b;
    if (isAskCompleted.value && isBidCompleted.value) {
      isCompleteDisplay.value = true;
      //  update();
    }
  }

  // 매수,매도 호가 리스트 vo
  late ResOrderBookVo _resOrderBookVo = new ResOrderBookVo();
  late ResOrderBookVo _oldresOrderBookVo = new ResOrderBookVo();

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 5);

    print("UpbitWebSocketController onInit() 실행!!");
    _channelOrderbook = IOWebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
        pingInterval: Duration(seconds: 3));
    _channelTrade = IOWebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
        pingInterval: Duration(seconds: 3));
    _channelTicker = IOWebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
        pingInterval: Duration(seconds: 3));

    //호가 리스트는 매수,매도 2개의 widget 에 데이터를 넘겨주기위해 brodcast 으로 처리.
    _channelOrderbook.stream.listen((data) async {
      var bigestBidSizeRate = 0.0;
      var bigestAskSizeRate = 0.0;
      _resOrderBookVo = await compute(parseResOrderBookVo, data);

      //가장 큰 bid_size 를 기준값으로 다른 size들의 rate를 구한다.
      // bigestBidSizeRate = _resOrderBookVo.orderbook_units!
      //     .map<double>((e) => e.bid_size!)
      //     .reduce(max);

      _resOrderBookVo.orderbook_units?.forEach((element1) {
        bigestBidSizeRate = bigestBidSizeRate >= element1.bid_size!
            ? bigestBidSizeRate
            : element1.bid_size!;

        bigestAskSizeRate = bigestAskSizeRate >= element1.ask_size!
            ? bigestAskSizeRate
            : element1.ask_size!;
      });

      _resOrderBookVo.orderbook_units?.forEach((element1) {
        // Size 비율 구하기
        element1.bid_size_rate =
            ((element1.bid_size! / bigestBidSizeRate) * 100);
        element1.ask_size_rate = (element1.ask_size! / bigestAskSizeRate) * 100;

        //이전 데이터 와 비교
        _oldresOrderBookVo.orderbook_units?.forEach((element2) {
          if (element1.bid_price == element2.bid_price) {
            if (element1.bid_size! > element2.bid_size!) {
              element1.bid_plus_size =
                  (element1.bid_size! - element2.bid_size!);
              element1.bid_minus_size = 0.0;
            } else {
              element1.bid_minus_size =
                  (element2.bid_size! - element1.bid_size!);
              element1.bid_plus_size = 0.0;
            }
            if (element1.ask_price == element2.ask_price) {
              if (element1.ask_size! > element2.ask_size!) {
                element1.ask_plus_size =
                    (element1.ask_size! - element2.ask_size!);
                element1.ask_minus_size = 0.0;
              } else {
                element1.ask_minus_size =
                    (element2.ask_size! - element1.ask_size!);
                element1.ask_plus_size = 0.0;
              }
            }
            //한번 비교됐으면 다음데이터를 스킵하고 바로 다음 으로 넘어간다.
            return;
          }
        });
        _oldresOrderBookVo.orderbook_units
            ?.removeWhere((element) => element.bid_price == element1.bid_price);
      });
      // 비교후 다시 집어 넣는다.
      _oldresOrderBookVo = _resOrderBookVo;
      if (!streamOrderBook.isClosed) {
        streamOrderBook.sink.add(_resOrderBookVo);
      }
    });

    //현재가 ticker  2개의 widget 에 데이터를 넘겨주기위해 brodcast 으로 처리.
    _channelTicker.stream.listen((data) async {
      ResTickerVo _data = await compute(parseResTickerVo, data);

      print(" _data.prev_closing_price : ${_data.prev_closing_price}");
      //어제 종가 셋팅
      if (_data.prev_closing_price != null) {
        yesterdayPrice = _data.prev_closing_price!;
      }

      //당일고가
      todayHighPrice = _data.high_price!;
      //당일저가
      todayLowPrice = _data.low_price!;

      if (!streamTiker.isClosed) {
        streamTiker.sink.add(_data);
      }
    });

    _channelTrade.stream.listen((data) async {
      ResTradeVo _data = await compute(parseResTradeVo, data);
      tradePrice = _data.trade_price!;
      if (listResTradeVo.length > tradeListLimit) {
        listResTradeVo.removeAt(0);
      }
      listResTradeVo.add(_data);
      if (!streamTrade.isClosed) {
        streamTrade.sink.add(listResTradeVo);
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

    if (_type == "ticker") {
      _channelTicker.sink.add(_req.toString());
    } else if (_type == "trade") {
      _channelTrade.sink.add(_req.toString());
    } else if (_type == "orderbook") {
      _channelOrderbook.sink.add(_req.toString());
    }
  }

  @override
  void onClose() {
    print("dispose!!!!!! ");
    streamTiker.close();
    streamOrderBook.close();
    streamTradeForce.close();
    scrollController.dispose();
    scrollController1.dispose();
    scrollController2.dispose();

    _channelOrderbook.sink.close(status.goingAway);
    _channelTrade.sink.close(status.goingAway);
    _channelTicker.sink.close(status.goingAway);

    super.dispose();
  }
}
