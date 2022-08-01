import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/upbit/vo/ResOrderBookUnitsVo.dart';
import 'package:flutter/foundation.dart';

/*
 **************************************************
 *
 *
 *
 **************************************************
*/
class ResOrderBookVo {
  String? type;
  String? code;
  int? timestamp;
  double? total_ask_size;
  double? total_bid_size;
  List<ResOrderBookUnitsVo>? orderbook_units;
  ResOrderBookVo({
    this.type,
    this.code,
    this.timestamp,
    this.total_ask_size,
    this.total_bid_size,
    this.orderbook_units,
  });

  ResOrderBookVo copyWith({
    String? type,
    String? code,
    int? timestamp,
    double? total_ask_size,
    double? total_bid_size,
    List<ResOrderBookUnitsVo>? orderbook_units,
  }) {
    return ResOrderBookVo(
      type: type ?? this.type,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      total_ask_size: total_ask_size ?? this.total_ask_size,
      total_bid_size: total_bid_size ?? this.total_bid_size,
      orderbook_units: orderbook_units ?? this.orderbook_units,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'code': code,
      'timestamp': timestamp,
      'total_ask_size': total_ask_size,
      'total_bid_size': total_bid_size,
      'orderbook_units': orderbook_units?.map((x) => x.toMap()).toList(),
    };
  }

  factory ResOrderBookVo.fromMap(Map<String, dynamic> map) {
    return ResOrderBookVo(
      type: map['type'],
      code: map['code'],
      timestamp: map['timestamp']?.toInt(),
      total_ask_size: map['total_ask_size']?.toDouble(),
      total_bid_size: map['total_bid_size']?.toDouble(),
      orderbook_units: map['orderbook_units'] != null
          ? List<ResOrderBookUnitsVo>.from(map['orderbook_units']
              ?.map((x) => ResOrderBookUnitsVo.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResOrderBookVo.fromJson(String source) =>
      ResOrderBookVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResOrderBookVo(type: $type, code: $code, timestamp: $timestamp, total_ask_size: $total_ask_size, total_bid_size: $total_bid_size, orderbook_units: $orderbook_units)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResOrderBookVo &&
        other.type == type &&
        other.code == code &&
        other.timestamp == timestamp &&
        other.total_ask_size == total_ask_size &&
        other.total_bid_size == total_bid_size &&
        listEquals(other.orderbook_units, orderbook_units);
  }

  @override
  int get hashCode {
    return type.hashCode ^
        code.hashCode ^
        timestamp.hashCode ^
        total_ask_size.hashCode ^
        total_bid_size.hashCode ^
        orderbook_units.hashCode;
  }
}
