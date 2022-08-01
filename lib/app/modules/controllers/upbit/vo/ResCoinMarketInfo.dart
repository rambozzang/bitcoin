import 'dart:convert';

class ResCoinMarketInfo {
  String? market;
  String? trade_date;
  double? trade_time;
  String? trade_date_kst;
  String? trade_time_kst;
  double? trade_timestamp;
  double? opening_price;
  double? high_price;
  double? low_price;
  double? trade_price;
  double? prev_closing_price;
  String? change;
  double? change_price;
  double? change_rate;
  double? signed_change_price;
  double? signed_change_rate;
  double? trade_volume;
  double? acc_trade_price;
  double? acc_trade_price_24h;
  double? acc_trade_volume;
  double? acc_trade_volume_24h;
  double? highest_52_week_price;
  double? highest_52_week_date;
  double? lowest_52_week_price;
  double? lowest_52_week_date;
  double? timestamp;
  ResCoinMarketInfo({
    this.market,
    this.trade_date,
    this.trade_time,
    this.trade_date_kst,
    this.trade_time_kst,
    this.trade_timestamp,
    this.opening_price,
    this.high_price,
    this.low_price,
    this.trade_price,
    this.prev_closing_price,
    this.change,
    this.change_price,
    this.change_rate,
    this.signed_change_price,
    this.signed_change_rate,
    this.trade_volume,
    this.acc_trade_price,
    this.acc_trade_price_24h,
    this.acc_trade_volume,
    this.acc_trade_volume_24h,
    this.highest_52_week_price,
    this.highest_52_week_date,
    this.lowest_52_week_price,
    this.lowest_52_week_date,
    this.timestamp,
  });

  ResCoinMarketInfo copyWith({
    String? market,
    String? trade_date,
    double? trade_time,
    String? trade_date_kst,
    String? trade_time_kst,
    double? trade_timestamp,
    double? opening_price,
    double? high_price,
    double? low_price,
    double? trade_price,
    double? prev_closing_price,
    String? change,
    double? change_price,
    double? change_rate,
    double? signed_change_price,
    double? signed_change_rate,
    double? trade_volume,
    double? acc_trade_price,
    double? acc_trade_price_24h,
    double? acc_trade_volume,
    double? acc_trade_volume_24h,
    double? highest_52_week_price,
    double? highest_52_week_date,
    double? lowest_52_week_price,
    double? lowest_52_week_date,
    double? timestamp,
  }) {
    return ResCoinMarketInfo(
      market: market ?? this.market,
      trade_date: trade_date ?? this.trade_date,
      trade_time: trade_time ?? this.trade_time,
      trade_date_kst: trade_date_kst ?? this.trade_date_kst,
      trade_time_kst: trade_time_kst ?? this.trade_time_kst,
      trade_timestamp: trade_timestamp ?? this.trade_timestamp,
      opening_price: opening_price ?? this.opening_price,
      high_price: high_price ?? this.high_price,
      low_price: low_price ?? this.low_price,
      trade_price: trade_price ?? this.trade_price,
      prev_closing_price: prev_closing_price ?? this.prev_closing_price,
      change: change ?? this.change,
      change_price: change_price ?? this.change_price,
      change_rate: change_rate ?? this.change_rate,
      signed_change_price: signed_change_price ?? this.signed_change_price,
      signed_change_rate: signed_change_rate ?? this.signed_change_rate,
      trade_volume: trade_volume ?? this.trade_volume,
      acc_trade_price: acc_trade_price ?? this.acc_trade_price,
      acc_trade_price_24h: acc_trade_price_24h ?? this.acc_trade_price_24h,
      acc_trade_volume: acc_trade_volume ?? this.acc_trade_volume,
      acc_trade_volume_24h: acc_trade_volume_24h ?? this.acc_trade_volume_24h,
      highest_52_week_price:
          highest_52_week_price ?? this.highest_52_week_price,
      highest_52_week_date: highest_52_week_date ?? this.highest_52_week_date,
      lowest_52_week_price: lowest_52_week_price ?? this.lowest_52_week_price,
      lowest_52_week_date: lowest_52_week_date ?? this.lowest_52_week_date,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'trade_date': trade_date,
      'trade_time': trade_time,
      'trade_date_kst': trade_date_kst,
      'trade_time_kst': trade_time_kst,
      'trade_timestamp': trade_timestamp,
      'opening_price': opening_price,
      'high_price': high_price,
      'low_price': low_price,
      'trade_price': trade_price,
      'prev_closing_price': prev_closing_price,
      'change': change,
      'change_price': change_price,
      'change_rate': change_rate,
      'signed_change_price': signed_change_price,
      'signed_change_rate': signed_change_rate,
      'trade_volume': trade_volume,
      'acc_trade_price': acc_trade_price,
      'acc_trade_price_24h': acc_trade_price_24h,
      'acc_trade_volume': acc_trade_volume,
      'acc_trade_volume_24h': acc_trade_volume_24h,
      'highest_52_week_price': highest_52_week_price,
      'highest_52_week_date': highest_52_week_date,
      'lowest_52_week_price': lowest_52_week_price,
      'lowest_52_week_date': lowest_52_week_date,
      'timestamp': timestamp,
    };
  }

  factory ResCoinMarketInfo.fromMap(Map<String, dynamic> map) {
    return ResCoinMarketInfo(
      market: map['market'],
      trade_date: map['trade_date'],
      trade_time: map['trade_time']?.toDouble(),
      trade_date_kst: map['trade_date_kst'],
      trade_time_kst: map['trade_time_kst'],
      trade_timestamp: map['trade_timestamp']?.toDouble(),
      opening_price: map['opening_price']?.toDouble(),
      high_price: map['high_price']?.toDouble(),
      low_price: map['low_price']?.toDouble(),
      trade_price: map['trade_price']?.toDouble(),
      prev_closing_price: map['prev_closing_price']?.toDouble(),
      change: map['change'],
      change_price: map['change_price']?.toDouble(),
      change_rate: map['change_rate']?.toDouble(),
      signed_change_price: map['signed_change_price']?.toDouble(),
      signed_change_rate: map['signed_change_rate']?.toDouble(),
      trade_volume: map['trade_volume']?.toDouble(),
      acc_trade_price: map['acc_trade_price']?.toDouble(),
      acc_trade_price_24h: map['acc_trade_price_24h']?.toDouble(),
      acc_trade_volume: map['acc_trade_volume']?.toDouble(),
      acc_trade_volume_24h: map['acc_trade_volume_24h']?.toDouble(),
      highest_52_week_price: map['highest_52_week_price']?.toDouble(),
      highest_52_week_date: map['highest_52_week_date']?.toDouble(),
      lowest_52_week_price: map['lowest_52_week_price']?.toDouble(),
      lowest_52_week_date: map['lowest_52_week_date']?.toDouble(),
      timestamp: map['timestamp']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResCoinMarketInfo.fromJson(String source) =>
      ResCoinMarketInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResCoinMarketInfo(market: $market, trade_date: $trade_date, trade_time: $trade_time, trade_date_kst: $trade_date_kst, trade_time_kst: $trade_time_kst, trade_timestamp: $trade_timestamp, opening_price: $opening_price, high_price: $high_price, low_price: $low_price, trade_price: $trade_price, prev_closing_price: $prev_closing_price, change: $change, change_price: $change_price, change_rate: $change_rate, signed_change_price: $signed_change_price, signed_change_rate: $signed_change_rate, trade_volume: $trade_volume, acc_trade_price: $acc_trade_price, acc_trade_price_24h: $acc_trade_price_24h, acc_trade_volume: $acc_trade_volume, acc_trade_volume_24h: $acc_trade_volume_24h, highest_52_week_price: $highest_52_week_price, highest_52_week_date: $highest_52_week_date, lowest_52_week_price: $lowest_52_week_price, lowest_52_week_date: $lowest_52_week_date, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResCoinMarketInfo &&
        other.market == market &&
        other.trade_date == trade_date &&
        other.trade_time == trade_time &&
        other.trade_date_kst == trade_date_kst &&
        other.trade_time_kst == trade_time_kst &&
        other.trade_timestamp == trade_timestamp &&
        other.opening_price == opening_price &&
        other.high_price == high_price &&
        other.low_price == low_price &&
        other.trade_price == trade_price &&
        other.prev_closing_price == prev_closing_price &&
        other.change == change &&
        other.change_price == change_price &&
        other.change_rate == change_rate &&
        other.signed_change_price == signed_change_price &&
        other.signed_change_rate == signed_change_rate &&
        other.trade_volume == trade_volume &&
        other.acc_trade_price == acc_trade_price &&
        other.acc_trade_price_24h == acc_trade_price_24h &&
        other.acc_trade_volume == acc_trade_volume &&
        other.acc_trade_volume_24h == acc_trade_volume_24h &&
        other.highest_52_week_price == highest_52_week_price &&
        other.highest_52_week_date == highest_52_week_date &&
        other.lowest_52_week_price == lowest_52_week_price &&
        other.lowest_52_week_date == lowest_52_week_date &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return market.hashCode ^
        trade_date.hashCode ^
        trade_time.hashCode ^
        trade_date_kst.hashCode ^
        trade_time_kst.hashCode ^
        trade_timestamp.hashCode ^
        opening_price.hashCode ^
        high_price.hashCode ^
        low_price.hashCode ^
        trade_price.hashCode ^
        prev_closing_price.hashCode ^
        change.hashCode ^
        change_price.hashCode ^
        change_rate.hashCode ^
        signed_change_price.hashCode ^
        signed_change_rate.hashCode ^
        trade_volume.hashCode ^
        acc_trade_price.hashCode ^
        acc_trade_price_24h.hashCode ^
        acc_trade_volume.hashCode ^
        acc_trade_volume_24h.hashCode ^
        highest_52_week_price.hashCode ^
        highest_52_week_date.hashCode ^
        lowest_52_week_price.hashCode ^
        lowest_52_week_date.hashCode ^
        timestamp.hashCode;
  }
}
