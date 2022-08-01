import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCandleVo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResCoinInfoVo.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

enum HttpMethod { get, post }

class ApiProvier extends GetConnect {
  Future<dynamic> CallAPI_NoParam(String url) async {
    try {
      var response;

      response = await get<dynamic>(url);

      if (response.status.hasError) {
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {
      print("error : " + e.toString());
      return e.toString();
    }
  }

  Future<dynamic> CallAPI_WithParam(
      String url, HttpMethod httpMethod, dynamic queryParams) async {
    try {
      var response;
      if (httpMethod == HttpMethod.get) {
        response = await get<dynamic>(url,
            headers: {
              "Accept": "application/json",
              "Access-Control_Allow_Origin": "*"
            },
            query: queryParams);
      } else {
        response = await post<dynamic>(url, queryParams);
      }
      if (response.status.hasError) {
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {
      print("error : " + e.toString());
      return e.toString();
    }
  }

  Future<Response<List<ResCoinInfoVo>>> getCoinList2() =>
      get<List<ResCoinInfoVo>>("https://api.upbit.com/v1/market/all");

  Future<Response<List<ResCoinInfoVo>>> getCoinTickerfByMarkets(
          String markets) =>
      get<List<ResCoinInfoVo>>(
          "https://api.upbit.com/v1/ticker?markets=" + markets);

  // 업비트 캔들 조회하기
  Future<List<ResCandleVo>> getCandleByupbit(
      int _min, String _market, String _to, int _cnt) async {
    print("https://api.upbit.com/v1/candles/minutes/" +
        _min.toString() +
        "?market=$_market&to=$_to&count=$_cnt");
    try {
      var response = await get<List<dynamic>>(
          "https://api.upbit.com/v1/candles/minutes/" +
              _min.toString() +
              "?market=$_market&to=$_to&count=$_cnt");

      if (response.status.hasError) {
        return Future.error(response.statusText!);
      } else {
        List<ResCandleVo> list = (response.body as List)
            .map((data) => ResCandleVo.fromMap(data))
            .toList();
        return list;
      }
    } catch (e) {
      print("error : " + e.toString());
      return [];
    }
  }

  Future<List<ResCoinInfoVo>> getCoinList() async {
    try {
      var response = await get<List<dynamic>>(
          "https://api.upbit.com/v1/market/all",
          headers: {
            "Accept": "application/json",
            "Access-Control_Allow_Origin": "*"
          });

      if (response.status.hasError) {
        return Future.error(response.statusText!);
      } else {
        List<ResCoinInfoVo> list = (response.body as List)
            .map((data) => ResCoinInfoVo.fromMap(data))
            .toList();
        return list;
      }
    } catch (e) {
      print("eeee: " + e.toString());

      return [];
    }
  }

  //
  Future<List<Candle>> fetchCandles(
      {required String symbol, required String interval, int? endTime}) async {
    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval" +
            (endTime != null ? "&endTime=$endTime" : ""));
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  Future<List<String>> fetchSymbols() async {
    final uri = Uri.parse("https://api.binance.com/api/v3/ticker/price");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => e["symbol"] as String)
        .toList();
  }

  WebSocketChannel establishConnection(String symbol, String interval) {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws'),
    );
    channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": [symbol + "@kline_" + interval],
          "id": 1
        },
      ),
    );
    return channel;
  }
}
