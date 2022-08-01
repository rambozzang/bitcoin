import 'dart:convert';

class ResTradeVo {
  String? type;
  String? code;
  int? timestamp;
  String? trade_date;
  String? trade_time;
  int? trade_timestamp;
  double? trade_price;
  double? trade_volume;
  String? ask_bid;
  double? prev_closing_price;
  String? change;
  double? change_price;
  int? sequential_id;
  String? stream_type;
  ResTradeVo({
    this.type,
    this.code,
    this.timestamp,
    this.trade_date,
    this.trade_time,
    this.trade_timestamp,
    this.trade_price,
    this.trade_volume,
    this.ask_bid,
    this.prev_closing_price,
    this.change,
    this.change_price,
    this.sequential_id,
    this.stream_type,
  });

  ResTradeVo copyWith({
    String? type,
    String? code,
    int? timestamp,
    String? trade_date,
    String? trade_time,
    int? trade_timestamp,
    double? trade_price,
    double? trade_volume,
    String? ask_bid,
    double? prev_closing_price,
    String? change,
    double? change_price,
    int? sequential_id,
    String? stream_type,
  }) {
    return ResTradeVo(
      type: type ?? this.type,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      trade_date: trade_date ?? this.trade_date,
      trade_time: trade_time ?? this.trade_time,
      trade_timestamp: trade_timestamp ?? this.trade_timestamp,
      trade_price: trade_price ?? this.trade_price,
      trade_volume: trade_volume ?? this.trade_volume,
      ask_bid: ask_bid ?? this.ask_bid,
      prev_closing_price: prev_closing_price ?? this.prev_closing_price,
      change: change ?? this.change,
      change_price: change_price ?? this.change_price,
      sequential_id: sequential_id ?? this.sequential_id,
      stream_type: stream_type ?? this.stream_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'code': code,
      'timestamp': timestamp,
      'trade_date': trade_date,
      'trade_time': trade_time,
      'trade_timestamp': trade_timestamp,
      'trade_price': trade_price,
      'trade_volume': trade_volume,
      'ask_bid': ask_bid,
      'prev_closing_price': prev_closing_price,
      'change': change,
      'change_price': change_price,
      'sequential_id': sequential_id,
      'stream_type': stream_type,
    };
  }

  factory ResTradeVo.fromMap(Map<String, dynamic> map) {
    return ResTradeVo(
      type: map['type'],
      code: map['code'],
      timestamp: map['timestamp']?.toInt(),
      trade_date: map['trade_date'],
      trade_time: map['trade_time'],
      trade_timestamp: map['trade_timestamp']?.toInt(),
      trade_price: map['trade_price']?.toDouble(),
      trade_volume: map['trade_volume']?.toDouble(),
      ask_bid: map['ask_bid'],
      prev_closing_price: map['prev_closing_price']?.toDouble(),
      change: map['change'],
      change_price: map['change_price']?.toDouble(),
      sequential_id: map['sequential_id']?.toInt(),
      stream_type: map['stream_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResTradeVo.fromJson(String source) =>
      ResTradeVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResTradeVo(type: $type, code: $code, timestamp: $timestamp, trade_date: $trade_date, trade_time: $trade_time, trade_timestamp: $trade_timestamp, trade_price: $trade_price, trade_volume: $trade_volume, ask_bid: $ask_bid, prev_closing_price: $prev_closing_price, change: $change, change_price: $change_price, sequential_id: $sequential_id, stream_type: $stream_type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResTradeVo &&
        other.type == type &&
        other.code == code &&
        other.timestamp == timestamp &&
        other.trade_date == trade_date &&
        other.trade_time == trade_time &&
        other.trade_timestamp == trade_timestamp &&
        other.trade_price == trade_price &&
        other.trade_volume == trade_volume &&
        other.ask_bid == ask_bid &&
        other.prev_closing_price == prev_closing_price &&
        other.change == change &&
        other.change_price == change_price &&
        other.sequential_id == sequential_id &&
        other.stream_type == stream_type;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        code.hashCode ^
        timestamp.hashCode ^
        trade_date.hashCode ^
        trade_time.hashCode ^
        trade_timestamp.hashCode ^
        trade_price.hashCode ^
        trade_volume.hashCode ^
        ask_bid.hashCode ^
        prev_closing_price.hashCode ^
        change.hashCode ^
        change_price.hashCode ^
        sequential_id.hashCode ^
        stream_type.hashCode;
  }
}
