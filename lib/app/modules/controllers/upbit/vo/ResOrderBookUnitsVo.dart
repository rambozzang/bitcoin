import 'dart:convert';

class ResOrderBookUnitsVo {
  double? ask_price;
  double? bid_price;
  double? ask_size;
  double? ask_size_rate;
  double? bid_size;
  double? bid_size_rate;
  double? ask_plus_size;
  double? bid_plus_size;
  double? ask_minus_size;
  double? bid_minus_size;
  double? ask_persent;
  double? bid_persent;
  ResOrderBookUnitsVo({
    this.ask_price,
    this.bid_price,
    this.ask_size,
    this.ask_size_rate,
    this.bid_size,
    this.bid_size_rate,
    this.ask_plus_size,
    this.bid_plus_size,
    this.ask_minus_size,
    this.bid_minus_size,
    this.ask_persent,
    this.bid_persent,
  });

  ResOrderBookUnitsVo copyWith({
    double? ask_price,
    double? bid_price,
    double? ask_size,
    double? ask_size_rate,
    double? bid_size,
    double? bid_size_rate,
    double? ask_plus_size,
    double? bid_plus_size,
    double? ask_minus_size,
    double? bid_minus_size,
    double? ask_persent,
    double? bid_persent,
  }) {
    return ResOrderBookUnitsVo(
      ask_price: ask_price ?? this.ask_price,
      bid_price: bid_price ?? this.bid_price,
      ask_size: ask_size ?? this.ask_size,
      ask_size_rate: ask_size_rate ?? this.ask_size_rate,
      bid_size: bid_size ?? this.bid_size,
      bid_size_rate: bid_size_rate ?? this.bid_size_rate,
      ask_plus_size: ask_plus_size ?? this.ask_plus_size,
      bid_plus_size: bid_plus_size ?? this.bid_plus_size,
      ask_minus_size: ask_minus_size ?? this.ask_minus_size,
      bid_minus_size: bid_minus_size ?? this.bid_minus_size,
      ask_persent: ask_persent ?? this.ask_persent,
      bid_persent: bid_persent ?? this.bid_persent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ask_price': ask_price,
      'bid_price': bid_price,
      'ask_size': ask_size,
      'ask_size_rate': ask_size_rate,
      'bid_size': bid_size,
      'bid_size_rate': bid_size_rate,
      'ask_plus_size': ask_plus_size,
      'bid_plus_size': bid_plus_size,
      'ask_minus_size': ask_minus_size,
      'bid_minus_size': bid_minus_size,
      'ask_persent': ask_persent,
      'bid_persent': bid_persent,
    };
  }

  factory ResOrderBookUnitsVo.fromMap(Map<String, dynamic> map) {
    return ResOrderBookUnitsVo(
      ask_price: map['ask_price']?.toDouble(),
      bid_price: map['bid_price']?.toDouble(),
      ask_size: map['ask_size']?.toDouble(),
      ask_size_rate: map['ask_size_rate']?.toDouble(),
      bid_size: map['bid_size']?.toDouble(),
      bid_size_rate: map['bid_size_rate']?.toDouble(),
      ask_plus_size: map['ask_plus_size']?.toDouble(),
      bid_plus_size: map['bid_plus_size']?.toDouble(),
      ask_minus_size: map['ask_minus_size']?.toDouble(),
      bid_minus_size: map['bid_minus_size']?.toDouble(),
      ask_persent: map['ask_persent']?.toDouble(),
      bid_persent: map['bid_persent']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResOrderBookUnitsVo.fromJson(String source) =>
      ResOrderBookUnitsVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResOrderBookUnitsVo(ask_price: $ask_price, bid_price: $bid_price, ask_size: $ask_size, ask_size_rate: $ask_size_rate, bid_size: $bid_size, bid_size_rate: $bid_size_rate, ask_plus_size: $ask_plus_size, bid_plus_size: $bid_plus_size, ask_minus_size: $ask_minus_size, bid_minus_size: $bid_minus_size, ask_persent: $ask_persent, bid_persent: $bid_persent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResOrderBookUnitsVo &&
        other.ask_price == ask_price &&
        other.bid_price == bid_price &&
        other.ask_size == ask_size &&
        other.ask_size_rate == ask_size_rate &&
        other.bid_size == bid_size &&
        other.bid_size_rate == bid_size_rate &&
        other.ask_plus_size == ask_plus_size &&
        other.bid_plus_size == bid_plus_size &&
        other.ask_minus_size == ask_minus_size &&
        other.bid_minus_size == bid_minus_size &&
        other.ask_persent == ask_persent &&
        other.bid_persent == bid_persent;
  }

  @override
  int get hashCode {
    return ask_price.hashCode ^
        bid_price.hashCode ^
        ask_size.hashCode ^
        ask_size_rate.hashCode ^
        bid_size.hashCode ^
        bid_size_rate.hashCode ^
        ask_plus_size.hashCode ^
        bid_plus_size.hashCode ^
        ask_minus_size.hashCode ^
        bid_minus_size.hashCode ^
        ask_persent.hashCode ^
        bid_persent.hashCode;
  }
}
