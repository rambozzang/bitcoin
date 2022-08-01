import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:bitsumb2/app/data/binanceRepo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/ApiProvier.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqBodyVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqTicketVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCandleVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTradeVo.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nonce/nonce.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<ResOrderBookVo> parseResOrderBookVo(dynamic data) async {
  return ResOrderBookVo.fromMap(
      json.decode(String.fromCharCodes(Uint8List.fromList(data))));
}

Future<ResTickerVo> parseResTickerVo(dynamic data) async {
  return ResTickerVo.fromMap(
      json.decode(String.fromCharCodes(Uint8List.fromList(data))));
}

Future<ResTradeVo> parseResTradeVo(dynamic data) async {
  return ResTradeVo.fromMap(
      json.decode(String.fromCharCodes(Uint8List.fromList(data))));
}

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitMainController extends GetxController
    // ignore: deprecated_member_use
    with
        GetTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  BinanceRepository _binaceRepo = BinanceRepository();
  var flSpots = [].obs;
  void setflSpots(dynamic _d) {
    this.flSpots.addAll(_d);
    update();
  }

  ApiProvier _apiProvider = ApiProvier();

  final String _url = "wss://api.upbit.com/websocket/v1";
  // Tabbar index 정보
  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late TabController tabController;
  // Order 내 매수 매수 구분 탭바
  late TabController tabOrderController;
  late TabController tabTradeController;

  TextEditingController textCtrl = TextEditingController(text: "");
  TextEditingController get getTextCtrl => this.textCtrl;

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

  late WebSocketChannel _channelTrade;
  late WebSocketChannel _channelOrderbook;
  late WebSocketChannel _channelTicker;
  WebSocketChannel get socketOrderbook => this._channelOrderbook;
  WebSocketChannel get socketTrade => this._channelTrade;
  WebSocketChannel get socketTicker => this._channelTicker;

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

  // 메인 스크롤 및 매수,매도 호가 리스트 스크롤 컨트롤러
  ScrollController scrollController = ScrollController();
  ScrollController scrollOrderController = ScrollController();
  ScrollController scrollTikerController = ScrollController();

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

  //차트 그리기에 필요한 변수
  var candlellist = <Candle>[].obs;
  setCandlelist(dynamic _l) {
    candlellist = _l;
    update();
  }

  void doSearch() {
    print(textCtrl.text);
  }

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

    textCtrl.addListener(doSearch);

    print("UpbitMainController onInit() 실행!!");
    _channelOrderbook = WebSocketChannel.connect(
      Uri.parse(_url),
    );
    // pingInterval: Duration(seconds: 3));
    _channelTrade = WebSocketChannel.connect(
      Uri.parse(_url),
    );
    // pingInterval: Duration(seconds: 3));
    _channelTicker = WebSocketChannel.connect(
      Uri.parse(_url),
    );
    // pingInterval: Duration(seconds: 3));

    //호가 리스트는 매수,매도 2개의 widget 에 데이터를 넘겨주기위해 brodcast 으로 처리.
    _channelOrderbook.stream.listen((data) async {
      // orderProc(await parseResOrderBookVo(data));
      orderProc(await compute(parseResOrderBookVo, data));
    });

    _channelTicker.stream.listen((data) async {
      tikerProc(await parseResTickerVo(data));
      // tikerProc(await compute(parseResTickerVo, data));
    });

    _channelTrade.stream.listen((data) async {
      tradeProc(await parseResTradeVo(data));
      // tradeProc(await compute(parseResTradeVo, data));
    });

    //ar value = Get.arguments;
    coinCode = Get.arguments[0];
    coinName = Get.arguments[1];
    this.send("orderbook", coinCode);
    this.send("trade", coinCode);
    this.send("ticker", coinCode);

    // chart 정보 불러 오기
    // getCandleData();
    super.onInit();
  }

  // 바이낸스 캔들 가져오기
  void getCandleDataByBinance() async {
    var _list = [];
    int j = 0;
    // 당일 오전 9시 부터 데이터 수신
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 09, 00);

    // chart 정보 불러 오기
    // 30m : 48개
    // 15m : 96개
    // 1h : 24개
    List<Candle> _data = await _binaceRepo.fetchCandlesWithStartTime(
        symbol: coinCode.split("-")[1] + "USDT",
        interval: "15m",
        startTime: today.millisecondsSinceEpoch); // 24*4=  96

    for (var i = 0; i <= 96; i++) {
      if (i == (_data.length - 1)) break;
      // print("${i.toDouble()}  ${_data[i].date} :  ${_data[i].close}");
      _list.add(FlSpot(j.toDouble(), _data[i].close));
      j++;
    }
    if (_list.length > 0) setflSpots(_list);
  }

  Future<List<Candle>> getCandleByUpbit(int min, int cnt) async {
    var _ls = <Candle>[];

    var now = new DateTime.now();
    String _to = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      final _res = await _apiProvider.getCandleByupbit(min, coinCode, _to, cnt);
      var _data = _res.toList();

      // candle_date_time_kst": "2022-05-11T00:55:00",
      // "timestamp": 1652198138803,
      for (var i = 0; i <= 96; i++) {
        if (i == (_data.length - 1)) break;
        _ls.add(Candle(
            date: DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:00.000').format(
                DateTime.fromMillisecondsSinceEpoch(
                    _data[i].timestamp.toInt()))),
            //  date: DateTime.parse(_data[i].candle_date_time_kst),
            high: _data[i].high_price,
            low: _data[i].low_price,
            open: _data[i].opening_price,
            close: _data[i].trade_price,
            volume: _data[i].candle_acc_trade_volume));
      }
    } catch (e) {
      print(e.toString());
    }
    return _ls;
    // if (_ls.length > 0) setCandlelist(_ls);
  }

  // 업비트 상단에 미니 캔들 가져오기
  void getCandleFlSpotByUpbit() async {
    var now = new DateTime.now();
    String defaultDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    var _list = [];
    // 코인 리스트 가져오기
    int _min = 15; // 1,3,5,10,15,30,60,240 분
    var _market = coinCode; // 코인 KRW-BTC
    var _to =
        defaultDate; // yyyy-MM-dd HH:mm:ss 값 없을시 최근 캔들 (이 날짜기준으로 과거데이터를 가져옴)
    int _cnt = 60; // _to 날짜기준 가져올 과거데이터 건수 defaultDate 날짜부터 09시까지 의 카운트수

    // _cnt 구하기
    // 1.기준시간이 09 이전 이후 인지 판단한다.
    if (now.hour < 9) {
      // 1-1. 09시 이전이면 어제 09를 기준으로 한다.
      String _a = DateFormat('yyyy-MM-dd 09:00:00')
          .format(DateTime.now().subtract(Duration(days: 1)));

      _cnt =
          DateTime.parse(defaultDate).difference(DateTime.parse(_a)).inMinutes;
    } else {
      // 1-2. 09시 이훠이면 당일 09를 기준으로 한다.
      DateTime _dd =
          DateTime.parse(DateFormat('yyyy-MM-dd 09:00:00').format(now));
      DateTime _ee = DateTime.parse(defaultDate);
      _cnt = _ee.difference(_dd).inMinutes;
    }

    _cnt = ((_cnt + 1) / 15).ceil(); //0일때를 대비 1를 더하고  15분기준이므로 나눈다.
    if (_cnt < 10) _cnt = 10; // 최소 10개는 가져온다.

    final _res = await _apiProvider.getCandleByupbit(_min, _market, _to, _cnt);
    var _data = _res.reversed.toList();
    for (var i = 0; i <= 96; i++) {
      if (i == (_data.length - 1)) break;
      _list.add(FlSpot(i.toDouble(), _data[i].trade_price));
    }
    if (_list.length > 0) setflSpots(_list);
  }

  void tradeProc(ResTradeVo _data) {
    this.yesterdayPrice = _data.prev_closing_price!;

    tradePrice = _data.trade_price!;
    if (listResTradeVo.length > tradeListLimit) {
      listResTradeVo.removeAt(0);
    }
    listResTradeVo.add(_data);

    if (!streamTrade.isClosed) {
      streamTrade.sink.add(listResTradeVo);
    }
  }

  void tikerProc(ResTickerVo _data) {
    //어제 종가 셋팅
    this.yesterdayPrice = _data.prev_closing_price!;
    //당일고가
    todayHighPrice = _data.high_price!;
    //당일저가
    todayLowPrice = _data.low_price!;

    if (!streamTiker.isClosed) {
      streamTiker.sink.add(_data);
    }
  }

  void orderProc(ResOrderBookVo _data) {
    var bigestBidSizeRate = 0.0;
    var bigestAskSizeRate = 0.0;
    _resOrderBookVo = _data;

    //가장 큰 bid_size 를 기준값으로 다른 size들의 rate를 구한다.
    // bigestBidSizeRate = _resOrderBookVo.orderbook_units!
    //     .map<double>((e) => e.bid_size!)
    //     .reduce(max);
    _resOrderBookVo.orderbook_units?.forEach((element1) {
      //1.가장큰 size 를 구함.
      bigestBidSizeRate = bigestBidSizeRate >= element1.bid_size!
          ? bigestBidSizeRate
          : element1.bid_size!;

      bigestAskSizeRate = bigestAskSizeRate >= element1.ask_size!
          ? bigestAskSizeRate
          : element1.ask_size!;

      //2.전일대비 등락율 계산
      element1.ask_persent = ((element1.ask_price! /
              (this.yesterdayPrice == 0.0
                  ? element1.ask_price!
                  : this.yesterdayPrice) *
              100) -
          100);
      element1.bid_persent = ((element1.bid_price! /
              (this.yesterdayPrice == 0.0
                  ? element1.bid_price!
                  : this.yesterdayPrice) *
              100) -
          100);
    });

    // 시간을 비교해서 0.3초간은 데이터를 유지처리
    int _dif = 0;
    if (_oldresOrderBookVo.timestamp != null) {
      _dif = DateTime.fromMillisecondsSinceEpoch(_resOrderBookVo.timestamp!)
          .difference(DateTime.fromMillisecondsSinceEpoch(
              _oldresOrderBookVo.timestamp!))
          .inMilliseconds;
      print("_dif : $_dif");
    }

    _resOrderBookVo.orderbook_units?.forEach((element1) {
      // 1.Size 비율 구하기
      element1.bid_size_rate = ((element1.bid_size! / bigestBidSizeRate) * 100);
      element1.ask_size_rate = (element1.ask_size! / bigestAskSizeRate) * 100;

      // 2.이전 데이터 와 비교
      _oldresOrderBookVo.orderbook_units?.forEach((element2) {
        if (element1.bid_price == element2.bid_price) {
          if (element1.bid_size! > element2.bid_size!) {
            element1.bid_plus_size = (element1.bid_size! - element2.bid_size!);

            element1.bid_minus_size = 0.0;
          } else if (element1.bid_size! == element2.bid_size!) {
            // 시간을 비교해서 0.3초간은 데이터를 유지처리
            if (_dif < 3000 && element2.bid_minus_size != 0.0) {
              element1.bid_plus_size = element2.bid_plus_size;
            } else {
              element1.bid_plus_size = 0.0;
            }
            element1.bid_minus_size = 0.0;
          } else {
            element1.bid_minus_size = (element2.bid_size! - element1.bid_size!);
            if (_dif < 3000 && element2.bid_plus_size != 0.0) {
              element1.bid_minus_size = element2.bid_minus_size;
            } else {
              element1.bid_minus_size = 0.0;
            }
            element1.bid_plus_size = 0.0;
          }

          if (element1.ask_price == element2.ask_price) {
            if (element1.ask_size! > element2.ask_size!) {
              element1.ask_plus_size =
                  (element1.ask_size! - element2.ask_size!);

              if (_dif < 3000 && element2.ask_minus_size != 0.0) {
                element1.ask_plus_size = element2.ask_plus_size;
              } else {
                element1.ask_plus_size = 0.0;
              }
              element1.ask_minus_size = 0.0;
            } else {
              element1.ask_minus_size =
                  (element2.ask_size! - element1.ask_size!);

              if (_dif < 3000 && element2.ask_plus_size != 0.0) {
                element1.ask_minus_size = element2.ask_minus_size;
              } else {
                element1.ask_minus_size = 0.0;
              }
              element1.ask_plus_size = 0.0;
            }
          }

          // 3.한번 비교됐으면 다음데이터를 스킵하고 바로 다음 으로 넘어간다.
          return;
        }
      });
      // 비교한 데이터는 삭제 처리
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
    print("UpbitMainController() dispose!!!!!! ");
    streamTiker.close();
    streamOrderBook.close();
    streamTradeForce.close();
    scrollController.dispose();
    scrollOrderController.dispose();
    scrollTikerController.dispose();

    _channelOrderbook.sink.close(status.goingAway);
    _channelTrade.sink.close(status.goingAway);
    _channelTicker.sink.close(status.goingAway);

    super.dispose();
  }
}
