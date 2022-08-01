import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubReq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController extends GetxController {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  late final WebSocketChannel? _channel;

  WebSocketChannel? get socket => _channel;

  // 호가 스트림
  //Rx<String> _tickerdata = "" as Rx<String>;

  // 체결 스트림
  //Rx<String> _transactiondata = "" as Rx<String>;

  // 변경호가 스트림
  //Rx<String> _orderbookdepthdata = "" as Rx<String>;

  @override
  void onInit() {
    super.onInit();

    print("WebSocketController onInit() 실행!!");
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://pubwss.bithumb.com/pub/ws'),
    );
  }

  // 현재가 호출 ticker
  // {"type" :  "ticker", "symbols" : ["BTC_KRW", "ETH_KRW"] , "tickTypes":["30H","1H","12H", "24H", "MID"]}
  void sendTicker() {
    PubReq _req = new PubReq();

    _req.type = "ticker";
    _req.symbols = ["BTC_KRW", "ETH_KRW"];
    _req.tickTypes = ["30H", "1H", "12H", "24H", "MID"];

    _channel!.sink.add(_req.toJson());
  }

  // 체결 transaction
  // {"type" :  "transaction", "symbols" : ["BTC_KRW", "ETH_KRW"] }
  void sendTransaction() {
    PubReq _req = new PubReq();
    _req.type = "transaction";
    _req.symbols = ["BTC_KRW", "ETH_KRW"];
    _channel!.sink.add(_req.toJson());
  }

  // 변경호가 orderbookdepth
  // {"type" :  "orderbookdepth", "symbols" : ["BTC_KRW", "ETH_KRW"] }
  void sendOrderBook() {
    PubReq _req = new PubReq();
    _req.type = "orderbookdepth";
    _req.symbols = ["EFI_KRW"];
    _channel!.sink.add(_req.toJson());
  }

  @override
  void dispose() {
    _channel!.sink.close();
    super.dispose();
  }
}
