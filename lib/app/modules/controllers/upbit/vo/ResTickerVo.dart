import 'dart:convert';

class ResTickerVo {
  String? type;
  String? code;
  double? opening_price;
  double? high_price;
  double? low_price;
  double? trade_price;
  double? prev_closing_price;
  String? change;
  double? change_price;
  double? signed_change_price;
  double? change_rate;
  double? signed_change_rate;

  double? trade_volume;
  double? acc_trade_volume;
  double? acc_trade_volume_24h;
  double? acc_trade_price;
  double? acc_trade_price_24h;

  String? trade_date;
  String? trade_time;
  double? trade_timestamp;

  String? ask_bid;

  double? acc_ask_volume;
  double? acc_bid_volume;
  double? highest_52_week_price;
  String? highest_52_week_date;
  double? lowest_52_week_price;
  String? lowest_52_week_date;

  String? trade_status;
  String? market_state;
  String? market_state_for_ios;

  bool? isTrading_suspended;
  String? delisting_date;
  String? market_warning;
  double? timestamp;
  String? stream_type;
  ResTickerVo({
    this.type,
    this.code,
    this.opening_price,
    this.high_price,
    this.low_price,
    this.trade_price,
    this.prev_closing_price,
    this.change,
    this.change_price,
    this.signed_change_price,
    this.change_rate,
    this.signed_change_rate,
    this.trade_volume,
    this.acc_trade_volume,
    this.acc_trade_volume_24h,
    this.acc_trade_price,
    this.acc_trade_price_24h,
    this.trade_date,
    this.trade_time,
    this.trade_timestamp,
    this.ask_bid,
    this.acc_ask_volume,
    this.acc_bid_volume,
    this.highest_52_week_price,
    this.highest_52_week_date,
    this.lowest_52_week_price,
    this.lowest_52_week_date,
    this.trade_status,
    this.market_state,
    this.market_state_for_ios,
    this.isTrading_suspended,
    this.delisting_date,
    this.market_warning,
    this.timestamp,
    this.stream_type,
  });

  ResTickerVo copyWith({
    String? type,
    String? code,
    double? opening_price,
    double? high_price,
    double? low_price,
    double? trade_price,
    double? prev_closing_price,
    String? change,
    double? change_price,
    double? signed_change_price,
    double? change_rate,
    double? signed_change_rate,
    double? trade_volume,
    double? acc_trade_volume,
    double? acc_trade_volume_24h,
    double? acc_trade_price,
    double? acc_trade_price_24h,
    String? trade_date,
    String? trade_time,
    double? trade_timestamp,
    String? ask_bid,
    double? acc_ask_volume,
    double? acc_bid_volume,
    double? highest_52_week_price,
    String? highest_52_week_date,
    double? lowest_52_week_price,
    String? lowest_52_week_date,
    String? trade_status,
    String? market_state,
    String? market_state_for_ios,
    bool? isTrading_suspended,
    String? delisting_date,
    String? market_warning,
    double? timestamp,
    String? stream_type,
  }) {
    return ResTickerVo(
      type: type ?? this.type,
      code: code ?? this.code,
      opening_price: opening_price ?? this.opening_price,
      high_price: high_price ?? this.high_price,
      low_price: low_price ?? this.low_price,
      trade_price: trade_price ?? this.trade_price,
      prev_closing_price: prev_closing_price ?? this.prev_closing_price,
      change: change ?? this.change,
      change_price: change_price ?? this.change_price,
      signed_change_price: signed_change_price ?? this.signed_change_price,
      change_rate: change_rate ?? this.change_rate,
      signed_change_rate: signed_change_rate ?? this.signed_change_rate,
      trade_volume: trade_volume ?? this.trade_volume,
      acc_trade_volume: acc_trade_volume ?? this.acc_trade_volume,
      acc_trade_volume_24h: acc_trade_volume_24h ?? this.acc_trade_volume_24h,
      acc_trade_price: acc_trade_price ?? this.acc_trade_price,
      acc_trade_price_24h: acc_trade_price_24h ?? this.acc_trade_price_24h,
      trade_date: trade_date ?? this.trade_date,
      trade_time: trade_time ?? this.trade_time,
      trade_timestamp: trade_timestamp ?? this.trade_timestamp,
      ask_bid: ask_bid ?? this.ask_bid,
      acc_ask_volume: acc_ask_volume ?? this.acc_ask_volume,
      acc_bid_volume: acc_bid_volume ?? this.acc_bid_volume,
      highest_52_week_price:
          highest_52_week_price ?? this.highest_52_week_price,
      highest_52_week_date: highest_52_week_date ?? this.highest_52_week_date,
      lowest_52_week_price: lowest_52_week_price ?? this.lowest_52_week_price,
      lowest_52_week_date: lowest_52_week_date ?? this.lowest_52_week_date,
      trade_status: trade_status ?? this.trade_status,
      market_state: market_state ?? this.market_state,
      market_state_for_ios: market_state_for_ios ?? this.market_state_for_ios,
      isTrading_suspended: isTrading_suspended ?? this.isTrading_suspended,
      delisting_date: delisting_date ?? this.delisting_date,
      market_warning: market_warning ?? this.market_warning,
      timestamp: timestamp ?? this.timestamp,
      stream_type: stream_type ?? this.stream_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'code': code,
      'opening_price': opening_price,
      'high_price': high_price,
      'low_price': low_price,
      'trade_price': trade_price,
      'prev_closing_price': prev_closing_price,
      'change': change,
      'change_price': change_price,
      'signed_change_price': signed_change_price,
      'change_rate': change_rate,
      'signed_change_rate': signed_change_rate,
      'trade_volume': trade_volume,
      'acc_trade_volume': acc_trade_volume,
      'acc_trade_volume_24h': acc_trade_volume_24h,
      'acc_trade_price': acc_trade_price,
      'acc_trade_price_24h': acc_trade_price_24h,
      'trade_date': trade_date,
      'trade_time': trade_time,
      'trade_timestamp': trade_timestamp,
      'ask_bid': ask_bid,
      'acc_ask_volume': acc_ask_volume,
      'acc_bid_volume': acc_bid_volume,
      'highest_52_week_price': highest_52_week_price,
      'highest_52_week_date': highest_52_week_date,
      'lowest_52_week_price': lowest_52_week_price,
      'lowest_52_week_date': lowest_52_week_date,
      'trade_status': trade_status,
      'market_state': market_state,
      'market_state_for_ios': market_state_for_ios,
      'isTrading_suspended': isTrading_suspended,
      'delisting_date': delisting_date,
      'market_warning': market_warning,
      'timestamp': timestamp,
      'stream_type': stream_type,
    };
  }

  factory ResTickerVo.fromMap(Map<String, dynamic> map) {
    return ResTickerVo(
      type: map['type'],
      code: map['code'],
      opening_price: map['opening_price']?.toDouble(),
      high_price: map['high_price']?.toDouble(),
      low_price: map['low_price']?.toDouble(),
      trade_price: map['trade_price']?.toDouble(),
      prev_closing_price: map['prev_closing_price']?.toDouble(),
      change: map['change'],
      change_price: map['change_price']?.toDouble(),
      signed_change_price: map['signed_change_price']?.toDouble(),
      change_rate: map['change_rate']?.toDouble(),
      signed_change_rate: map['signed_change_rate']?.toDouble(),
      trade_volume: map['trade_volume']?.toDouble(),
      acc_trade_volume: map['acc_trade_volume']?.toDouble(),
      acc_trade_volume_24h: map['acc_trade_volume_24h']?.toDouble(),
      acc_trade_price: map['acc_trade_price']?.toDouble(),
      acc_trade_price_24h: map['acc_trade_price_24h']?.toDouble(),
      trade_date: map['trade_date'],
      trade_time: map['trade_time'],
      trade_timestamp: map['trade_timestamp']?.toDouble(),
      ask_bid: map['ask_bid'],
      acc_ask_volume: map['acc_ask_volume']?.toDouble(),
      acc_bid_volume: map['acc_bid_volume']?.toDouble(),
      highest_52_week_price: map['highest_52_week_price']?.toDouble(),
      highest_52_week_date: map['highest_52_week_date'],
      lowest_52_week_price: map['lowest_52_week_price']?.toDouble(),
      lowest_52_week_date: map['lowest_52_week_date'],
      trade_status: map['trade_status'],
      market_state: map['market_state'],
      market_state_for_ios: map['market_state_for_ios'],
      isTrading_suspended: map['isTrading_suspended'],
      delisting_date: map['delisting_date'],
      market_warning: map['market_warning'],
      timestamp: map['timestamp']?.toDouble(),
      stream_type: map['stream_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResTickerVo.fromJson(String source) =>
      ResTickerVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResTickerVo(type: $type, code: $code, opening_price: $opening_price, high_price: $high_price, low_price: $low_price, trade_price: $trade_price, prev_closing_price: $prev_closing_price, change: $change, change_price: $change_price, signed_change_price: $signed_change_price, change_rate: $change_rate, signed_change_rate: $signed_change_rate, trade_volume: $trade_volume, acc_trade_volume: $acc_trade_volume, acc_trade_volume_24h: $acc_trade_volume_24h, acc_trade_price: $acc_trade_price, acc_trade_price_24h: $acc_trade_price_24h, trade_date: $trade_date, trade_time: $trade_time, trade_timestamp: $trade_timestamp, ask_bid: $ask_bid, acc_ask_volume: $acc_ask_volume, acc_bid_volume: $acc_bid_volume, highest_52_week_price: $highest_52_week_price, highest_52_week_date: $highest_52_week_date, lowest_52_week_price: $lowest_52_week_price, lowest_52_week_date: $lowest_52_week_date, trade_status: $trade_status, market_state: $market_state, market_state_for_ios: $market_state_for_ios, isTrading_suspended: $isTrading_suspended, delisting_date: $delisting_date, market_warning: $market_warning, timestamp: $timestamp, stream_type: $stream_type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResTickerVo &&
        other.type == type &&
        other.code == code &&
        other.opening_price == opening_price &&
        other.high_price == high_price &&
        other.low_price == low_price &&
        other.trade_price == trade_price &&
        other.prev_closing_price == prev_closing_price &&
        other.change == change &&
        other.change_price == change_price &&
        other.signed_change_price == signed_change_price &&
        other.change_rate == change_rate &&
        other.signed_change_rate == signed_change_rate &&
        other.trade_volume == trade_volume &&
        other.acc_trade_volume == acc_trade_volume &&
        other.acc_trade_volume_24h == acc_trade_volume_24h &&
        other.acc_trade_price == acc_trade_price &&
        other.acc_trade_price_24h == acc_trade_price_24h &&
        other.trade_date == trade_date &&
        other.trade_time == trade_time &&
        other.trade_timestamp == trade_timestamp &&
        other.ask_bid == ask_bid &&
        other.acc_ask_volume == acc_ask_volume &&
        other.acc_bid_volume == acc_bid_volume &&
        other.highest_52_week_price == highest_52_week_price &&
        other.highest_52_week_date == highest_52_week_date &&
        other.lowest_52_week_price == lowest_52_week_price &&
        other.lowest_52_week_date == lowest_52_week_date &&
        other.trade_status == trade_status &&
        other.market_state == market_state &&
        other.market_state_for_ios == market_state_for_ios &&
        other.isTrading_suspended == isTrading_suspended &&
        other.delisting_date == delisting_date &&
        other.market_warning == market_warning &&
        other.timestamp == timestamp &&
        other.stream_type == stream_type;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        code.hashCode ^
        opening_price.hashCode ^
        high_price.hashCode ^
        low_price.hashCode ^
        trade_price.hashCode ^
        prev_closing_price.hashCode ^
        change.hashCode ^
        change_price.hashCode ^
        signed_change_price.hashCode ^
        change_rate.hashCode ^
        signed_change_rate.hashCode ^
        trade_volume.hashCode ^
        acc_trade_volume.hashCode ^
        acc_trade_volume_24h.hashCode ^
        acc_trade_price.hashCode ^
        acc_trade_price_24h.hashCode ^
        trade_date.hashCode ^
        trade_time.hashCode ^
        trade_timestamp.hashCode ^
        ask_bid.hashCode ^
        acc_ask_volume.hashCode ^
        acc_bid_volume.hashCode ^
        highest_52_week_price.hashCode ^
        highest_52_week_date.hashCode ^
        lowest_52_week_price.hashCode ^
        lowest_52_week_date.hashCode ^
        trade_status.hashCode ^
        market_state.hashCode ^
        market_state_for_ios.hashCode ^
        isTrading_suspended.hashCode ^
        delisting_date.hashCode ^
        market_warning.hashCode ^
        timestamp.hashCode ^
        stream_type.hashCode;
  }
}
