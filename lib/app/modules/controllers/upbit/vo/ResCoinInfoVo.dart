import 'dart:convert';

class ResCoinInfoVo {
  String market;
  String korean_name;
  String english_name;
  double now_price;
  double yesterday_rate;
  double trade_money;
  String change_yn;
  ResCoinInfoVo({
    required this.market,
    required this.korean_name,
    required this.english_name,
    required this.now_price,
    required this.yesterday_rate,
    required this.trade_money,
    required this.change_yn,
  });

  ResCoinInfoVo copyWith({
    String? market,
    String? korean_name,
    String? english_name,
    double? now_price,
    double? yesterday_rate,
    double? trade_money,
    String? change_yn,
  }) {
    return ResCoinInfoVo(
      market: market ?? this.market,
      korean_name: korean_name ?? this.korean_name,
      english_name: english_name ?? this.english_name,
      now_price: now_price ?? this.now_price,
      yesterday_rate: yesterday_rate ?? this.yesterday_rate,
      trade_money: trade_money ?? this.trade_money,
      change_yn: change_yn ?? this.change_yn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'korean_name': korean_name,
      'english_name': english_name,
      'now_price': now_price,
      'yesterday_rate': yesterday_rate,
      'trade_money': trade_money,
      'change_yn': change_yn,
    };
  }

  factory ResCoinInfoVo.fromMap(Map<String, dynamic> map) {
    return ResCoinInfoVo(
      market: map['market'] ?? '',
      korean_name: map['korean_name'] ?? '',
      english_name: map['english_name'] ?? '',
      now_price: map['now_price']?.toDouble() ?? 0.0,
      yesterday_rate: map['yesterday_rate']?.toDouble() ?? 0.0,
      trade_money: map['trade_money']?.toDouble() ?? 0.0,
      change_yn: map['change_yn'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResCoinInfoVo.fromJson(String source) =>
      ResCoinInfoVo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResCoinInfoVo(market: $market, korean_name: $korean_name, english_name: $english_name, now_price: $now_price, yesterday_rate: $yesterday_rate, trade_money: $trade_money, change_yn: $change_yn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResCoinInfoVo &&
        other.market == market &&
        other.korean_name == korean_name &&
        other.english_name == english_name &&
        other.now_price == now_price &&
        other.yesterday_rate == yesterday_rate &&
        other.trade_money == trade_money &&
        other.change_yn == change_yn;
  }

  @override
  int get hashCode {
    return market.hashCode ^
        korean_name.hashCode ^
        english_name.hashCode ^
        now_price.hashCode ^
        yesterday_rate.hashCode ^
        trade_money.hashCode ^
        change_yn.hashCode;
  }
}
