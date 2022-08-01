import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqBodyVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqTicketVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonce/nonce.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitTradeController extends GetxController
    // ignore: deprecated_member_use
    with
        GetSingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  late WebSocketChannel _channelTrade;
  late TabController tabController;

  StreamController<String> streamTradeForce = new StreamController();
// 검색- 단위 KRW, BTC, USDT , 관심
  var _searchType = "KRW".obs;
  List<String> _searchTypeList = ["KRW", "BTC", "USDT", "관심"];
  String get getSearchType => this._searchType.value;

  // 화면 최초 로딩 완료여부
  RxBool initdata = false.obs;

  // get.toName 으로 넘어온 코인코드,명
  var coinCode = "";
  var coinName = "";

  WebSocketChannel get socketTrade => this._channelTrade;

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

  @override
  void onInit() {
    print("UpbitWebSocketController onInit() 실행!!");

    _channelTrade = IOWebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
        pingInterval: Duration(seconds: 3));

    //Tab 클릭이벤트 감지
    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        //2씩 호출되는거 방지하기 위함
        this._searchType.value = _searchTypeList[tabController.index];
        print(this._searchType.value);
      }
    });

    //ar value = Get.arguments;
    coinCode = Get.arguments[0];
    coinName = Get.arguments[1];

    this.send("trade", coinCode);
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

    _channelTrade.sink.add(_req.toString());
  }

  @override
  void onClose() {
    print("dispose!!!!!! ");

    streamTradeForce.close();
    scrollController.dispose();

    _channelTrade.sink.close(status.goingAway);

    super.dispose();
  }
}
