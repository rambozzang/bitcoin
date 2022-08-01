import 'dart:convert';

import 'package:bitsumb2/app/data/CandelModel.dart';
import 'package:bitsumb2/app/data/binanceRepo.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpBitListController.dart';
import 'package:bitsumb2/app/modules/controllers/upbit/UpbitMainController.dart';
import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:candlesticks_plus/src/models/candle_style.dart';

class UpbitChartViewBak extends StatefulWidget {
  const UpbitChartViewBak({Key? key}) : super(key: key);

  @override
  State<UpbitChartViewBak> createState() => _UpbitChartViewBakViewState();
}

class _UpbitChartViewBakViewState extends State<UpbitChartViewBak> {
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
    fetchSymbols().then((value) {
      symbols = value;
      if (symbols.isNotEmpty) fetchCandles(symbols[0], currentInterval);
    });

    // coin
    // currentSymbol = controller.coinCode;
    // print("currentSymbol : $currentSymbol");

    // // coninlist
    // controllerlist.allCoinInfoList
    //     .forEach((element) => symbols.add(element.market));

    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) _channel!.sink.close();
    super.dispose();
  }

  Future<List<String>> fetchSymbols() async {
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
      final data =
          await repository.fetchCandles(symbol: symbol, interval: interval);
      print("repository.fetchCandles > data : ${data.length}");

      // data.forEach((element) {
      //   print(
      //       "el: ${element.date} ${element.high}  ${element.open}   ${element.volume}   ${element.low} ${element.maxMa}  ${element.minMa}  ");
      // });
      // connect to binance stream
      _channel =
          repository.establishConnection(symbol.toLowerCase(), currentInterval);
      // update candles
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = symbol;
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);

        // print("date 1= ${candles[0].date}");
        // print("date 2= ${candleTicker.candle.date}");
        // cehck if incoming candle is an update on current last candle, or a new one
        // print("1 : ${candles[0].date}");
        // print("2 : ${candleTicker.candle.date}");
        // print("3 : ${candles[0].open}");
        // print("4 : ${candleTicker.candle.open}");
        // print("5 : ${candles[0].date.difference(candles[1].date)}");

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

  Future<void> loadMoreCandles() async {
    try {
      // load candles info
      final data = await repository.fetchCandles(
          symbol: currentSymbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      candles.removeLast();
      setState(() {
        candles.addAll(data);
      });
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
          child: StreamBuilder(
            stream: _channel == null ? null : _channel!.stream,
            builder: (context, snapshot) {
              updateCandlesFromSnapshot(snapshot);
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
                //  watermark: "ooiiiiiiiia",
                actions: [
                  ToolBarAction(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                              width: 200,
                              //    color: Theme.of(context).digalogColor,
                              child: Wrap(
                                children: intervals
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: SizedBox(
                                            width: 0,
                                            height: 30,
                                            child: RawMaterialButton(
                                              elevation: 0,
                                              fillColor:
                                                  Theme.of(context).lightGold,
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
                    },
                    child: Text(
                      currentInterval,
                      style: TextStyle(
                        color: Theme.of(context).grayColor,
                      ),
                    ),
                  ),
                  ToolBarAction(
                    width: 100,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SymbolSearchModal(
                            symbols: symbols,
                            onSelect: (value) {
                              fetchCandles(value, currentInterval);
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      currentSymbol,
                      style: TextStyle(
                        color: Theme.of(context).grayColor,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
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
