import 'dart:convert';

//
// market=KRW-BTC&to=2018-07-24T00:00:00Z
class ReqCandleVo {
  String market;
  String to;
  int count;
  ReqCandleVo({
    required this.market,
    required this.to,
    required this.count,
  });

  ReqCandleVo copyWith({
    String? market,
    String? to,
    int? count,
  }) {
    return ReqCandleVo(
      market: market ?? this.market,
      to: to ?? this.to,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'to': to,
      'count': count,
    };
  }

  factory ReqCandleVo.fromMap(Map<String, dynamic> map) {
    return ReqCandleVo(
      market: map['market'] ?? '',
      to: map['to'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReqCandleVo.fromJson(String source) =>
      ReqCandleVo.fromMap(json.decode(source));

  @override
  String toString() => 'ReqCandleVo(market: $market, to: $to, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReqCandleVo &&
        other.market == market &&
        other.to == to &&
        other.count == count;
  }

  @override
  int get hashCode => market.hashCode ^ to.hashCode ^ count.hashCode;
}
