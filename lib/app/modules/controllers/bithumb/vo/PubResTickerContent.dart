import 'dart:convert';

class PubResTickerContent {
  String? symbol; // 통화코드
  String? tickType; // 변동 기ㄴㅣ간- 30M , 1H,12H, 24H, MID
  String? date; // 일자
  String? time; // 시간
  String? openPrice; // 시가
  String? closePrice; // 종가
  String? lowPrice; // 저가
  String? highPrice; // 고가
  String? value; // 누적거래금액
  String? volume; // 누적거래량
  String? sellVolume; // 매도누적거래량
  String? buyVolume; // 매수누적거래량
  String? prevClosePrice; //전일종가
  String? chgRate; // 변동률
  String? chgAmt; // 변동금액
  String? volumePower; // 체결강도
  PubResTickerContent({
    this.symbol,
    this.tickType,
    this.date,
    this.time,
    this.openPrice,
    this.closePrice,
    this.lowPrice,
    this.highPrice,
    this.value,
    this.volume,
    this.sellVolume,
    this.buyVolume,
    this.prevClosePrice,
    this.chgRate,
    this.chgAmt,
    this.volumePower,
  });

  PubResTickerContent copyWith({
    String? symbol,
    String? tickType,
    String? date,
    String? time,
    String? openPrice,
    String? closePrice,
    String? lowPrice,
    String? highPrice,
    String? value,
    String? volume,
    String? sellVolume,
    String? buyVolume,
    String? prevClosePrice,
    String? chgRate,
    String? chgAmt,
    String? volumePower,
  }) {
    return PubResTickerContent(
      symbol: symbol ?? this.symbol,
      tickType: tickType ?? this.tickType,
      date: date ?? this.date,
      time: time ?? this.time,
      openPrice: openPrice ?? this.openPrice,
      closePrice: closePrice ?? this.closePrice,
      lowPrice: lowPrice ?? this.lowPrice,
      highPrice: highPrice ?? this.highPrice,
      value: value ?? this.value,
      volume: volume ?? this.volume,
      sellVolume: sellVolume ?? this.sellVolume,
      buyVolume: buyVolume ?? this.buyVolume,
      prevClosePrice: prevClosePrice ?? this.prevClosePrice,
      chgRate: chgRate ?? this.chgRate,
      chgAmt: chgAmt ?? this.chgAmt,
      volumePower: volumePower ?? this.volumePower,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'tickType': tickType,
      'date': date,
      'time': time,
      'openPrice': openPrice,
      'closePrice': closePrice,
      'lowPrice': lowPrice,
      'highPrice': highPrice,
      'value': value,
      'volume': volume,
      'sellVolume': sellVolume,
      'buyVolume': buyVolume,
      'prevClosePrice': prevClosePrice,
      'chgRate': chgRate,
      'chgAmt': chgAmt,
      'volumePower': volumePower,
    };
  }

  factory PubResTickerContent.fromMap(Map<String, dynamic> map) {
    return PubResTickerContent(
      symbol: map['symbol'],
      tickType: map['tickType'],
      date: map['date'],
      time: map['time'],
      openPrice: map['openPrice'],
      closePrice: map['closePrice'],
      lowPrice: map['lowPrice'],
      highPrice: map['highPrice'],
      value: map['value'],
      volume: map['volume'],
      sellVolume: map['sellVolume'],
      buyVolume: map['buyVolume'],
      prevClosePrice: map['prevClosePrice'],
      chgRate: map['chgRate'],
      chgAmt: map['chgAmt'],
      volumePower: map['volumePower'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResTickerContent.fromJson(String source) =>
      PubResTickerContent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PubResTickerContent(symbol: $symbol, tickType: $tickType, date: $date, time: $time, openPrice: $openPrice, closePrice: $closePrice, lowPrice: $lowPrice, highPrice: $highPrice, value: $value, volume: $volume, sellVolume: $sellVolume, buyVolume: $buyVolume, prevClosePrice: $prevClosePrice, chgRate: $chgRate, chgAmt: $chgAmt, volumePower: $volumePower)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResTickerContent &&
        other.symbol == symbol &&
        other.tickType == tickType &&
        other.date == date &&
        other.time == time &&
        other.openPrice == openPrice &&
        other.closePrice == closePrice &&
        other.lowPrice == lowPrice &&
        other.highPrice == highPrice &&
        other.value == value &&
        other.volume == volume &&
        other.sellVolume == sellVolume &&
        other.buyVolume == buyVolume &&
        other.prevClosePrice == prevClosePrice &&
        other.chgRate == chgRate &&
        other.chgAmt == chgAmt &&
        other.volumePower == volumePower;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        tickType.hashCode ^
        date.hashCode ^
        time.hashCode ^
        openPrice.hashCode ^
        closePrice.hashCode ^
        lowPrice.hashCode ^
        highPrice.hashCode ^
        value.hashCode ^
        volume.hashCode ^
        sellVolume.hashCode ^
        buyVolume.hashCode ^
        prevClosePrice.hashCode ^
        chgRate.hashCode ^
        chgAmt.hashCode ^
        volumePower.hashCode;
  }
}
