import 'dart:convert';

import 'package:bitsumb2/app/data/CandelModel.dart';
import 'package:bitsumb2/app/data/binanceRepo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResTickerVo.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:candlesticks_plus/src/models/candle_style.dart';

class UpbitChartView extends StatefulWidget {
  const UpbitChartView({Key? key}) : super(key: key);

  @override
  State<UpbitChartView> createState() => _UpbitChartViewState();
}

class _UpbitChartViewState extends State<UpbitChartView> {
  final controller = Get.find<UpbitMainController>();
  final controllerlist = Get.find<UpBitListController>();
  BinanceRepository repository = BinanceRepository();

  List<Candle> candles = [];
  WebSocketChannel? _channel;
  bool themeIsDark = false;
  String currentInterval = "1m";
  final intervals = [
    '1m',
    '3m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    '3d',
    '1w',
    '1M',
  ];
  List<String> symbols = [];
  String currentSymbol = "";

  @override
  void initState() {
    // fetchSymbols().then((value) {
    //   symbols = value;
    //   if (symbols.isNotEmpty) fetchCandles(symbols[0], currentInterval);
    // });

    // coin
    currentSymbol = controller.coinCode;
    print("currentSymbol : $currentSymbol");

    // coninlist
    controllerlist.allCoinInfoList
        .forEach((element) => symbols.add(element.market));
    fetchCandles(currentSymbol, currentInterval);
    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) _channel!.sink.close();
    super.dispose();
  }

  Future<List<String>> fetchSymbols_del() async {
    try {
      // load candles info
      final data = await repository.fetchSymbols();
      return data;
    } catch (e) {
      // handle error
      return [];
    }
  }

  Future<void> fetchCandles(String symbol, String interval) async {
    // close current channel if exists
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    // clear last candle list
    setState(() {
      candles = [];
      currentInterval = interval;
    });

    try {
      // load candles info
      // final data =
      //     await repository.fetchCandles(symbol: symbol, interval: interval);

      int _min = 1; //  1분봉
      int _cnt = 200; // 최대 가져오는 건수
      final data = await controller.getCandleByUpbit(_min, _cnt);
      // print(data);
      // data.forEach((element) {
      //   print(
      //       "el: ${element.date} ${element.high}  ${element.open}   ${element.volume}   ${element.low} ${element.maxMa}  ${element.minMa}  ");
      // });
      //flutter: el: 2022-05-10 22:21:00.000 110450.0  0.0   1.17700316   110450.0 null  null
      //flutter: el: 2022-05-10 15:40:00.000 0.074745  0.074731   181.6705   0.074597 null  null
      // connect to binance stream
      // _channel =
      //     repository.establishConnection(symbol.toLowerCase(), currentInterval);

      //  repository.establishConnection(symbol.toLowerCase(), currentInterval);

      // update candles
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = controller.coinCode;
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  void updateCandlesFromSnapshot_old(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);

        // cehck if incoming candle is an update on current last candle, or a new one
        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          // update last candle
          candles[0] = candleTicker.candle;
        }
        // check if incoming new candle is next candle so the difrence
        // between times must be the same as last existing 2 candles
        else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date)) {
          // add new candle to list
          candles.insert(0, candleTicker.candle);
        }
      }
    }
  }

  void updateCandlesFromSnapshot2(AsyncSnapshot snapshot) async {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      // 1분봉을 호출해서 high 하고 low 다시 설정한다.
      //  final _data = await controller.getCandleByUpbit(1 , 1 );
      // final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      // final resTickerVo = ResTickerVo.fromMap(map);
      ResTickerVo resTickerVo = snapshot.data;
      final f = new DateFormat('yyyy-MM-dd hh:mm');
      DateTime _tradeDate = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:00.000')
          .format(DateTime.fromMillisecondsSinceEpoch(
              resTickerVo.trade_timestamp!.toInt())));
      // List<ResTickerVo> _data = snapshot.data;
      // ResTickerVo resTickerVo = _data[0];
      // print("date 1= ${candles[0].date}");
      // print("date 2= ${_tradeDate} ");
      // print("date 3= ${candles[0].open} ");
      // print("date 4= ${resTickerVo.opening_price} ");
      // print("date 3= ${candles[0].open} ");
      // print("date 4= ${resTickerVo.opening_price} ");
      // print("date 5= ${_tradeDate.difference(candles[0].date)} ");
      // print("date 6= ${candles[0].date.difference(candles[1].date)} ");

      if (candles[0].date == _tradeDate &&
          candles[0].open == resTickerVo.opening_price) {
        candles[0] = Candle(
            date: _tradeDate,
            high: resTickerVo.high_price!,
            low: resTickerVo.low_price!,
            open: resTickerVo.opening_price!,
            close: resTickerVo.trade_price!,
            volume: resTickerVo.trade_volume!);
      } else if (_tradeDate.difference(candles[0].date) ==
          candles[0].date.difference(candles[1].date)) {
        candles.insert(
            0,
            Candle(
                date: _tradeDate,
                high: resTickerVo.high_price!,
                low: resTickerVo.low_price!,
                open: resTickerVo.opening_price!,
                close: resTickerVo.trade_price!,
                volume: resTickerVo.trade_volume!));
      }
    }
  }

  Future<void> loadMoreCandles() async {
    try {
      // load candles info
      // final data = await repository.fetchCandles(
      //     symbol: currentSymbol,
      //     interval: currentInterval,
      //     endTime: candles.last.date.millisecondsSinceEpoch);
      // candles.removeLast();
      // setState(() {
      //   candles.addAll(data);
      // });

      final data = await controller.getCandleByUpbit(1, 200);
      candles.removeLast();
      candles.addAll(data);
    } catch (e) {
      // handle error
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeIsDark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: StreamBuilder<ResTickerVo>(
            stream: controller.streamTiker.stream,
            builder: (context, snapshot) {
              updateCandlesFromSnapshot2(snapshot);
              return Candlesticks(
                //  key: Key(currentSymbol + currentInterval),
                // indicators: indicators,
                showToolbar: true,
                candles: candles,
                onLoadMoreCandles: loadMoreCandles,
                candleStyle: CandleStyle(
                    bullColor: Utils.upbgcolor, bearColor: Utils.downbgcolor),
                // onRemoveIndicator: (String indicator) {
                //   setState(() {
                //     indicators = [...indicators];
                //     indicators
                //         .removeWhere((element) => element.name == indicator);
                //   });
                // },
                // watermark: "ooiiiiiiiia",
                actions: [
                  ToolBarAction(
                      width: 30,
                      onPressed: () {
                        MiniteBtnClick();
                      },
                      child: TabbarContents("틱")),
                  ToolBarAction(
                      width: 30,
                      onPressed: () {
                        MiniteBtnClick();
                      },
                      child: TabbarContents("분")),
                  ToolBarAction(
                    width: 30,
                    onPressed: () {
                      MiniteBtnClick();
                    },
                    child: TabbarContents("일"),
                  ),
                  ToolBarAction(
                    width: 30,
                    onPressed: () {
                      MiniteBtnClick();
                    },
                    child: TabbarContents("주"),
                  ),
                  ToolBarAction(
                    width: 30,
                    onPressed: () {
                      MiniteBtnClick();
                    },
                    child: TabbarContents("월"),
                  ),
                  ToolBarAction(
                    width: 32,
                    onPressed: () {
                      MiniteBtnClick();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.0),
                          color: Colors.grey[300],
                          border:
                              Border.all(width: 1, color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.aspect_ratio_outlined,
                            size: 20,
                          ),
                          // child: Text(
                          //   "□",
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  ToolBarAction(
                    width: 34,
                    onPressed: () {
                      MiniteBtnClick();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.0),
                          color: Colors.grey[300],
                          border:
                              Border.all(width: 1, color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.settings,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ToolBarAction(
                  //   width: 100,
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return SymbolSearchModal(
                  //           symbols: symbols,
                  //           onSelect: (value) {
                  //             fetchCandles(value, currentInterval);
                  //           },
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Text(
                  //     currentSymbol,
                  //     style: TextStyle(
                  //       color: Theme.of(context).grayColor,
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget TabbarContents(String title) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey[400]!),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  MiniteBtnClick() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: 200,
            //    color: Theme.of(context).digalogColor,
            child: Wrap(
              children: intervals
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: SizedBox(
                          width: 0,
                          height: 30,
                          child: RawMaterialButton(
                            elevation: 0,
                            fillColor: Theme.of(context).lightGold,
                            onPressed: () {
                              fetchCandles(currentSymbol, e);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              e,
                              style: TextStyle(
                                color: Theme.of(context).gold,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class SymbolSearchModal extends StatefulWidget {
  const SymbolSearchModal({
    Key? key,
    required this.onSelect,
    required this.symbols,
  }) : super(key: key);

  final Function(String symbol) onSelect;
  final List<String> symbols;

  @override
  State<SymbolSearchModal> createState() => _SymbolSearchModalState();
}

class _SymbolSearchModalState extends State<SymbolSearchModal> {
  String symbolSearch = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height * 0.75,
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    setState(() {
                      symbolSearch = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.symbols
                      .where((element) => element
                          .toLowerCase()
                          .contains(symbolSearch.toLowerCase()))
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 50,
                              height: 30,
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: Theme.of(context).lightGold,
                                onPressed: () {
                                  widget.onSelect(e);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: Theme.of(context).gold,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
