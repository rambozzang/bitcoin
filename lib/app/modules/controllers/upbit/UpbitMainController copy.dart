import 'dart:async';
import 'dart:convert';
import 'dart:core';
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

Future<dynamic> parseResponseVo(dynamic data) async {
  Uint8List bytes = Uint8List.fromList(data);
  String _byteStr = String.fromCharCodes(bytes);
  var _data = json.decode(_byteStr);

  print("${_data['type']}");
  if (_data['type'] == "ticker") {
    return ResTickerVo.fromMap(_data);
  } else if (_data['type'] == "orderbook") {
    return ResOrderBookVo.fromMap(_data);
  } else if (_data['type'] == "trade") {
    return ResTradeVo.fromMap(_data);
  }
}

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitMainController111 extends GetxController
    // ignore: deprecated_member_use
    with
        GetTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  // Tabbar index 정보
  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late TabController tabController;
  // Order 내 매수 매수 구분 탭바
  late TabController tabOrderController;
  late TabController tabTradeController;

  void changeRootPageIndex(int index) {
    pageIndex(index);
  }

// tiker 멀티 listen 을 위해 brodcat 처리
  StreamController<ResTickerVo> streamTiker = new StreamController.broadcast();
  // tiker 멀티 listen 을 위해 brodcat 처리
  StreamController<String> streamTradeForce = new StreamController.broadcast();
  // orderBook 멀티 listen 을 위해 brodcat 처리
  StreamController<ResOrderBookVo> streamOrderBook =
      new StreamController.broadcast();
  StreamController<List<ResTradeVo>> streamTrade =
      new StreamController.broadcast();

  late WebSocketChannel _channelOrderbook;

  WebSocketChannel get socketOrderbook => this._channelOrderbook;

  // 화면 최초 로딩 완료여부
  RxBool isCompleteOrderDisplay = false.obs;
  RxBool isCompleteTikerDisplay = false.obs;

  // 화면 최초 로딩 완료여부
  RxBool initdata = false.obs;
  //체결 리스트vo
  late List<ResTradeVo> listResTradeVo = [];
  int tradeListLimit = 25;

  // get.toName 으로 넘어온 코인코드,명
  var coinCode = "";
  var coinName = "";

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
  ScrollController scrollOrderController = ScrollController();
  ScrollController scrollTikerController = ScrollController();

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

// 호가 listview 그리기 완성여부
  var isOrderAskCompleted = false.obs;
  var isOrderBidCompleted = false.obs;

  void setOrderAskCompleted(bool _b) {
    isOrderAskCompleted.value = _b;
    //isCompleteDisplay.value = isBidCompleted.value ? true : false;
    if (isOrderAskCompleted.value && isOrderBidCompleted.value) {
      isCompleteOrderDisplay.value = true;
      //   update();
    }
  }

  void setOrderBidCompleted(bool _b) {
    isOrderBidCompleted.value = _b;
    if (isOrderAskCompleted.value && isOrderBidCompleted.value) {
      isCompleteOrderDisplay.value = true;
      //  update();
    }
  }

  // 호가 listview 그리기 완성여부
  var isTikerAskCompleted = false.obs;
  var isTikerBidCompleted = false.obs;

  void setTikerAskCompleted(bool _b) {
    isTikerAskCompleted.value = _b;
    //isCompleteDisplay.value = isBidCompleted.value ? true : false;
    if (isTikerAskCompleted.value && isTikerBidCompleted.value) {
      isCompleteTikerDisplay.value = true;
      //   update();
    }
  }

  void setTikerBidCompleted(bool _b) {
    isTikerBidCompleted.value = _b;
    if (isTikerAskCompleted.value && isTikerBidCompleted.value) {
      isCompleteTikerDisplay.value = true;
      //  update();
    }
  }

  // 매수,매도 호가 리스트 vo
  late ResOrderBookVo _resOrderBookVo = new ResOrderBookVo();
  late ResOrderBookVo _oldresOrderBookVo = new ResOrderBookVo();

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 5);
    tabOrderController = TabController(vsync: this, length: 3);
    //체결 tab 2개
    tabTradeController = TabController(vsync: this, length: 2);
    tabTradeController.addListener(() {
      if (!tabTradeController.indexIsChanging) {
        //2씩 호출되는거 방지하기 위함
      }
    });

    print("UpbitMainController onInit() 실행!!");
    _channelOrderbook = WebSocketChannel.connect(
      Uri.parse('wss://api.upbit.com/websocket/v1'),
    );

    // pingInterval: Duration(seconds: 3));

    //호가 리스트는 매수,매도 2개의 widget 에 데이터를 넘겨주기위해 brodcast 으로 처리.
    _channelOrderbook.stream.listen((data) async {
      var _data = await compute(parseResponseVo, data);

      if (_data.type == "orderbook") {
        _resOrderBookVo = _data;
        orderProc();
      } else if (_data.type == "ticker") {
        ResTickerVo _d = _data;
        tikerProc(_d);
      } else if (_data.type == "trade") {
        ResTradeVo _d = _data;
        tradeProc(_d);
      }
    });

    //ar value = Get.arguments;
    coinCode = Get.arguments[0];
    coinName = Get.arguments[1];
    this.send("orderbook", coinCode);
    this.send("trade", coinCode);
    this.send("ticker", coinCode);

    super.onInit();
  }

  void tradeProc(_data) {
    tradePrice = _data.trade_price!;
    if (listResTradeVo.length > tradeListLimit) {
      listResTradeVo.removeAt(0);
    }
    listResTradeVo.add(_data);
    if (!streamTrade.isClosed) {
      streamTrade.sink.add(listResTradeVo);
    }
  }

  void tikerProc(_data) {
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
  }

  void orderProc() {
    var bigestBidSizeRate = 0.0;
    var bigestAskSizeRate = 0.0;
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
      element1.bid_size_rate = ((element1.bid_size! / bigestBidSizeRate) * 100);
      element1.ask_size_rate = (element1.ask_size! / bigestAskSizeRate) * 100;

      //이전 데이터 와 비교
      _oldresOrderBookVo.orderbook_units?.forEach((element2) {
        if (element1.bid_price == element2.bid_price) {
          if (element1.bid_size! > element2.bid_size!) {
            element1.bid_plus_size = (element1.bid_size! - element2.bid_size!);
            element1.bid_minus_size = 0.0;
          } else {
            element1.bid_minus_size = (element2.bid_size! - element1.bid_size!);
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

    _channelOrderbook.sink.add(_req.toString());
  }

  @override
  void onClose() {
    print("dispose!!!!!! ");
    print("dispose!!!!!! ");
    streamTiker.close();
    streamOrderBook.close();
    streamTradeForce.close();
    scrollController.dispose();
    scrollOrderController.dispose();
    scrollTikerController.dispose();

    scrollController1.dispose();
    scrollController2.dispose();

    _channelOrderbook.sink.close(status.goingAway);
    super.dispose();
  }
}
