import 'dart:convert';

import 'package:flutter/foundation.dart';

// 현재가 ticker
// {"type" :  "ticker", "symbols" : ["BTC_KRW", "ETH_KRW"] , "tickTypes":["30H","1H","12H", "24H", "MID"]}

// 체결 transaction
// {"type" :  "transaction", "symbols" : ["BTC_KRW", "ETH_KRW"] }

// 변경호가 orderbookdepth
// {"type" :  "orderbookdepth", "symbols" : ["BTC_KRW", "ETH_KRW"] }

class PubReq {
  String? type;
  List<String>? symbols;
  List<String>? tickTypes;
  PubReq({
    this.type,
    this.symbols,
    this.tickTypes,
  });

  PubReq copyWith({
    String? type,
    List<String>? symbols,
    List<String>? tickTypes,
  }) {
    return PubReq(
      type: type ?? this.type,
      symbols: symbols ?? this.symbols,
      tickTypes: tickTypes ?? this.tickTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'symbols': symbols,
      'tickTypes': tickTypes,
    };
  }

  factory PubReq.fromMap(Map<String, dynamic> map) {
    return PubReq(
      type: map['type'],
      symbols: List<String>.from(map['symbols']),
      tickTypes: List<String>.from(map['tickTypes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PubReq.fromJson(String source) => PubReq.fromMap(json.decode(source));

  @override
  String toString() =>
      'PubReq(type: $type, symbols: $symbols, tickTypes: $tickTypes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubReq &&
        other.type == type &&
        listEquals(other.symbols, symbols) &&
        listEquals(other.tickTypes, tickTypes);
  }

  @override
  int get hashCode => type.hashCode ^ symbols.hashCode ^ tickTypes.hashCode;
}
