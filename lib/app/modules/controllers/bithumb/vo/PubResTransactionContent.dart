import 'dart:convert';

class PubResTransactionContent {
  String? symbol; // 코인심볼
  String? buySellGb; // 체결종류(1:매도체결, 2:매수체결)
  String? contPrice; // 체결가격
  String? contQty; // 체결수량
  String? contAmt; // 체결금액
  String? contDtm; // 체결시각
  String? updn; // 직전 시세와 비교 : up:상승 , dn:하락
  PubResTransactionContent({
    this.symbol,
    this.buySellGb,
    this.contPrice,
    this.contQty,
    this.contAmt,
    this.contDtm,
    this.updn,
  });

  PubResTransactionContent copyWith({
    String? symbol,
    String? buySellGb,
    String? contPrice,
    String? contQty,
    String? contAmt,
    String? contDtm,
    String? updn,
  }) {
    return PubResTransactionContent(
      symbol: symbol ?? this.symbol,
      buySellGb: buySellGb ?? this.buySellGb,
      contPrice: contPrice ?? this.contPrice,
      contQty: contQty ?? this.contQty,
      contAmt: contAmt ?? this.contAmt,
      contDtm: contDtm ?? this.contDtm,
      updn: updn ?? this.updn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'buySellGb': buySellGb,
      'contPrice': contPrice,
      'contQty': contQty,
      'contAmt': contAmt,
      'contDtm': contDtm,
      'updn': updn,
    };
  }

  factory PubResTransactionContent.fromMap(Map<String, dynamic> map) {
    return PubResTransactionContent(
      symbol: map['symbol'],
      buySellGb: map['buySellGb'],
      contPrice: map['contPrice'],
      contQty: map['contQty'],
      contAmt: map['contAmt'],
      contDtm: map['contDtm'],
      updn: map['updn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResTransactionContent.fromJson(String source) =>
      PubResTransactionContent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PubResTransactionContent(symbol: $symbol, buySellGb: $buySellGb, contPrice: $contPrice, contQty: $contQty, contAmt: $contAmt, contDtm: $contDtm, updn: $updn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResTransactionContent &&
        other.symbol == symbol &&
        other.buySellGb == buySellGb &&
        other.contPrice == contPrice &&
        other.contQty == contQty &&
        other.contAmt == contAmt &&
        other.contDtm == contDtm &&
        other.updn == updn;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        buySellGb.hashCode ^
        contPrice.hashCode ^
        contQty.hashCode ^
        contAmt.hashCode ^
        contDtm.hashCode ^
        updn.hashCode;
  }
}
