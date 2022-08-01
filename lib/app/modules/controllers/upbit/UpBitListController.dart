import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bitsumb2/app/modules/controllers/upbit/ApiProvier.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqBodyVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ReqTicketVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCoinInfoVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCoinMarketInfo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonce/nonce.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<ResTickerVo> parseResTickerVo(dynamic data) async {
  return ResTickerVo.fromMap(
      json.decode(String.fromCharCodes(Uint8List.fromList(data))));
}

class UpBitListController extends GetxController
    with StateMixin<List<ResCoinInfoVo>>, GetSingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  ApiProvier _apiProvider = ApiProvier();

  late ResCoinMarketInfo resCoinMarketInfo;

  late TabController tabController;
  TextEditingController textCtrl = TextEditingController(text: "");
  TextEditingController get getTextCtrl => this.textCtrl;

  late WebSocketChannel _channelTicker;
  WebSocketChannel get socketTicker => this._channelTicker;

  var _coinlist = new List<String>.empty(growable: true);
  var _req = new List.empty(growable: true);

  var closeBtnDisplay = false.obs;

  //socket 상태
  var _isSocketConnected = false;

  var favoriteCoinList = [].obs;

  void setFavoriteCoin(String _coin) {
    //1.코인 존재여부 확인
    if (!favoriteCoinList.contains(_coin)) {
      //2.코인 추가
      favoriteCoinList.add(_coin);
    } else {
      //3.코인 삭제
      favoriteCoinList.removeWhere((element) => element == _coin);
    }
  }

  // 코인정보 vo
  late ResCoinInfoVo resCoinInfoVo;
  // 코인정보 list에 보여줄 목록
  late List<ResCoinInfoVo> resCoinInfoList = [];
  // 코인전체 목록 list
  late List<ResCoinInfoVo> allCoinInfoList = [];
  // 이전데이터 비교할 목록
  late List<ResCoinInfoVo> oldresCoinInfoList = [];

  List<ResCoinInfoVo> get getresCoinInfoList => this.resCoinInfoList;

  // tiker 멀티 listen 을 위해 brodcat 처리
  StreamController<List<ResCoinInfoVo>> streamTiker =
      new StreamController.broadcast();

  // 검색- 단위 KRW, BTC, USDT , 관심
  var _searchType = "KRW".obs;
  List<String> _searchTypeList = ["KRW", "BTC", "USDT", "관심"];
  String get getSearchType => this._searchType.value;

  void setSearchType(String _v) {
    this.oldresCoinInfoList.clear();
    this._searchType.value = _v;
    // update();
  }

  // 한글 여주
  var _isHangul = true.obs;
  bool get getisHangul => this._isHangul.value;
  void setIsHangul(bool _b) {
    this._isHangul.value = _b;
    //  update();
  }

  // 코인전체 리스트 sort by NOW(현재가)) , RATE(전일대비) , SIZE(거래금액)
  var _sort = "".obs;
  var _sortDesc = true.obs; // DESC , ASC\
  String get getSort => this._sort.value;
  bool get getSortDesc => this._sortDesc.value;
  void setSort(String _s, bool _d) {
    this._sort.value = _s;
    this._sortDesc.value = _d;
    // update();
  }

  void doSearch() {
    if (textCtrl.text != "") {
      closeBtnDisplay.value = true;
    } else {
      closeBtnDisplay.value = false;
    }
  }

  void textClear() {
    textCtrl.text = '';
    closeBtnDisplay.value = false;
  }

  @override
  void onInit() {
    super.onInit();

    try {
      _channelTicker = WebSocketChannel.connect(
        Uri.parse('wss://api.upbit.com/websocket/v1'),
      );
    } catch (e) {
      print("e : $e");
    }

    // 코인 리스트 가져오기
    _apiProvider.getCoinList().then((response) {
      change(response, status: RxStatus.success());
      resCoinInfoList.clear();
      resCoinInfoList = [
        ...response.where(
            (element) => element.market.split("-")[0] == this._searchType.value)
      ];
      // 1 전체 리스트 담기
      allCoinInfoList.clear();
      allCoinInfoList.addAll(response.toList());

      // 2. _coinlist에 들어간 웹소켓 호출 하기
      this.send();
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });

    // Listener
    streamListen();

    //Tab 클릭이벤트 감지
    tabController = TabController(
        vsync: this, length: 4, animationDuration: Duration(milliseconds: 100));
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        //2씩 호출되는거 방지하기 위함
        this._searchType.value = _searchTypeList[tabController.index];
        print(this._searchType.value);
        setIsHangul(true);
        setSort("", true);

        // 탭에 해당하는 코인 리스트 셋팅
        resCoinInfoList.clear();
        resCoinInfoList = [
          ...allCoinInfoList.where((element) {
            return element.market.split("-")[0] == this._searchType.value;
          })
        ];
        // 소켓 재접속
        this.send();
      }
    });

    textCtrl.addListener(doSearch);
  }

  void socketCloseAndInit() {
    _channelTicker.sink.close(status.goingAway);
    _channelTicker = IOWebSocketChannel.connect(
      Uri.parse('wss://api.upbit.com/websocket/v1'),
    );
  }

  void reSocketInit() {
    ///websocket 실시간 호가 가져오기

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(
        "@@@@ reSocketInit() _isSocketConnected : ${this._isSocketConnected} ");
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    if (this._isSocketConnected == false) {
      socketCloseAndInit();
      send();
      streamListen();
    }
  }

  void streamListen() {
    _channelTicker.stream.listen((data) async {
      _isSocketConnected = true;
      // 데이터 파싱 처리
      ResTickerVo _data = await parseResTickerVo(data);
      // ResTickerVo _data = await compute(parseResTickerVo, data);

      resCoinInfoList.asMap().forEach((index, element) {
        if (element.market == _data.code) {
          // print(
          //     "${oldresCoinInfoList[index].now_price} - ${_data.trade_price}");
          if (oldresCoinInfoList.length > 0) {
            ResCoinInfoVo _vo = oldresCoinInfoList
                .firstWhere((_el) => _el.market == element.market);

            element.change_yn = _vo.now_price != _data.trade_price ? "Y" : "N";
          } else {
            element.change_yn = "N";
          }

          // KRW
          if (this._searchType.value == "KRW") {
            element.now_price = _data.trade_price!;
            element.trade_money = (_data.acc_trade_price_24h! / 1000000);
          } else if (this._searchType.value == "BTC") {
            element.now_price = _data.trade_price!;
            element.trade_money = (_data.acc_trade_price_24h! * 1000);
          } else if (this._searchType.value == "USDT") {
            element.now_price = _data.trade_price!;
            element.trade_money = (_data.acc_trade_price_24h! * 1000);
          }

          element.yesterday_rate = ((_data.signed_change_rate ?? 0) * 100);
        } else {
          element.change_yn = "N";
        }
      });

      oldresCoinInfoList.clear();
      oldresCoinInfoList.addAll(resCoinInfoList);

      if (!streamTiker.isClosed) {
        // sort 하기 현재가
        if (_sort == "NOW" && _sortDesc == true) {
          resCoinInfoList.sort((a, b) => a.now_price.compareTo(b.now_price));
        } else if (_sort == "RATE" && _sortDesc == true) {
          resCoinInfoList
              .sort((a, b) => a.yesterday_rate.compareTo(b.yesterday_rate));
        } else if (_sort == "SIZE" && _sortDesc == true) {
          resCoinInfoList
              .sort((a, b) => a.trade_money.compareTo(b.trade_money));
        } else if (_sort == "NOW" && _sortDesc == false) {
          resCoinInfoList.sort((a, b) => b.now_price.compareTo(a.now_price));
        } else if (_sort == "RATE" && _sortDesc == false) {
          resCoinInfoList
              .sort((a, b) => b.yesterday_rate.compareTo(a.yesterday_rate));
        } else if (_sort == "SIZE" && _sortDesc == false) {
          resCoinInfoList
              .sort((a, b) => b.trade_money.compareTo(a.trade_money));
        }

        // 코인명/실몰 검색
        // print(textCtrl.text);
        // if (textCtrl.text != "") {
        //   resCoinInfoList = resCoinInfoList
        //       .where((element) => element.korean_name
        //           .toLowerCase()
        //           .contains(textCtrl.text))
        //       .toList();
        // }

        streamTiker.sink.add(resCoinInfoList);
      }
    }, onDone: () {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print("@@@@  _channelTicker socket onDone !!!!! @@@@@");
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      _isSocketConnected = false;
      // Future.delayed(Duration(milliseconds: 500), () {
      //   reSocketInit();
      // });
    }, onError: (err) {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print("@@@@ Listcontroller _channelTicker socket Error : $err ");
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      _isSocketConnected = false;
      // Future.delayed(Duration(milliseconds: 500), () {
      //   reSocketInit();
      // });
    });
  }

  void send() {
    _req.clear();
    oldresCoinInfoList.clear();

    // 1.티켓 추가
    ReqTicketVo _ticket = new ReqTicketVo();
    _ticket.ticket = Nonce.generate();
    // 2.코인 추가
    //_coinlist.add("KRW-BTC");
    // 2. 웹소켓으로 요청할 코인 리스트 생성 _coinlist
    resCoinInfoList.forEach((el) {
      _coinlist.add(el.market);
    });

    // 3.바디(요청종목 + 코인리스트) 생성
    ReqBodyVo _reqBodyVo = new ReqBodyVo();
    _reqBodyVo.type = "ticker";
    _reqBodyVo.codes = _coinlist;

    // 4.최종 리트 생성 티켓 + 바디
    _req.add(_ticket.toJson());
    _req.add(_reqBodyVo.toJson());

    _channelTicker.sink.add(_req.toString());
  }

  @override
  void onClose() {
    print("dispose!");
    tabController.dispose();

    this.streamTiker.sink.close();
    this._channelTicker.sink.close(status.goingAway);
    super.dispose();
  }
}
