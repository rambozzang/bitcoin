import 'dart:convert';

//
// market=KRW-BTC&to=2018-07-24T00:00:00Z
class ResCandleVo {
  String market;
  String candle_data_time_utc; //기준시간(UTC)
  String candle_date_time_kst; // 기준시간(KST)
  double opening_price;
  double high_price;
  double low_price;
  double trade_price;
  double timestamp;
  double candle_acc_trade_price;
  double candle_acc_trade_volume;
  int unit;
  ResCandleVo({
    required this.market,
    required this.candle_data_time_utc,
    required this.candle_date_time_kst,
    required this.opening_price,
    required this.high_price,
    required this.low_price,
    required this.trade_price,
    required this.timestamp,
    required this.candle_acc_trade_price,
    required this.candle_acc_trade_volume,
    required this.unit,
  });

  ResCandleVo copyWith({
    String? market,
    String? candle_data_time_utc,
    String? candle_date_time_kst,
    double? opening_price,
    double? high_price,
    double? low_price,
    double? trade_price,
    double? timestamp,
    double? candle_acc_trade_price,
    double? candle_acc_trade_volume,
    int? unit,
  }) {
    return ResCandleVo(
      market: market ?? this.market,
      candle_data_time_utc: candle_data_time_utc ?? this.candle_data_time_utc,
      candle_date_time_kst: candle_date_time_kst ?? this.candle_date_time_kst,
      opening_price: opening_price ?? this.opening_price,
      high_price: high_price ?? this.high_price,
      low_price: low_price ?? this.low_price,
      trade_price: trade_price ?? this.trade_price,
      timestamp: timestamp ?? this.timestamp,
      candle_acc_trade_price:
          candle_acc_trade_price ?? this.candle_acc_trade_price,
      candle_acc_trade_volume:
          candle_acc_trade_volume ?? this.candle_acc_trade_volume,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'candle_data_time_utc': candle_data_time_utc,
      'candle_date_time_kst': candle_date_time_kst,
      'opening_price': opening_price,
      'high_price': high_price,
      'low_price': low_price,
      'trade_price': trade_price,
      'timestamp': timestamp,
      'candle_acc_trade_price': candle_acc_trade_price,
      'candle_acc_trade_volume': candle_acc_trade_volume,
      'unit': unit,
    };
  }

  factory ResCandleVo.fromMap(Map<String, dynamic> map) {
    return ResCandleVo(
      market: map['market'] ?? '',
      candle_data_time_utc: map['candle_data_time_utc'] ?? '',
      candle_date_time_kst: map['candle_date_time_kst'] ?? '',
      opening_price: map['opening_price']?.toDouble() ?? 0.0,
      high_price: map['high_price']?.toDouble() ?? 0.0,
      low_price: map['low_price']?.toDouble() ?? 0.0,
      trade_price: map['trade_price']?.toDouble() ?? 0.0,
      timestamp: map['timestamp']?.toDouble() ?? 0.0,
      candle_acc_trade_price: map['candle_acc_trade_price']?.toDouble() ?? 0.0,
      candle_acc_trade_volume:
          map['candle_acc_trade_volume']?.toDouble() ?? 0.0,
      unit: map['unit']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResCandleVo.fromJson(String source) =>
      ResCandleVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResCandleVo(market: $market, candle_data_time_utc: $candle_data_time_utc, candle_date_time_kst: $candle_date_time_kst, opening_price: $opening_price, high_price: $high_price, low_price: $low_price, trade_price: $trade_price, timestamp: $timestamp, candle_acc_trade_price: $candle_acc_trade_price, candle_acc_trade_volume: $candle_acc_trade_volume, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResCandleVo &&
        other.market == market &&
        other.candle_data_time_utc == candle_data_time_utc &&
        other.candle_date_time_kst == candle_date_time_kst &&
        other.opening_price == opening_price &&
        other.high_price == high_price &&
        other.low_price == low_price &&
        other.trade_price == trade_price &&
        other.timestamp == timestamp &&
        other.candle_acc_trade_price == candle_acc_trade_price &&
        other.candle_acc_trade_volume == candle_acc_trade_volume &&
        other.unit == unit;
  }

  @override
  int get hashCode {
    return market.hashCode ^
        candle_data_time_utc.hashCode ^
        candle_date_time_kst.hashCode ^
        opening_price.hashCode ^
        high_price.hashCode ^
        low_price.hashCode ^
        trade_price.hashCode ^
        timestamp.hashCode ^
        candle_acc_trade_price.hashCode ^
        candle_acc_trade_volume.hashCode ^
        unit.hashCode;
  }
}
