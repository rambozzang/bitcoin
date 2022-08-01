import 'dart:convert';

class PubResOrderBookDepthList {
  String? symbol; // 코인심볼
  String? orderType; //주문타임 - bid/ ask
  String? price; // 호가
  String? quantity; // 잔량
  String? total; // 건수
  PubResOrderBookDepthList({
    this.symbol,
    this.orderType,
    this.price,
    this.quantity,
    this.total,
  });

  PubResOrderBookDepthList copyWith({
    String? symbol,
    String? orderType,
    String? price,
    String? quantity,
    String? total,
  }) {
    return PubResOrderBookDepthList(
      symbol: symbol ?? this.symbol,
      orderType: orderType ?? this.orderType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'orderType': orderType,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  factory PubResOrderBookDepthList.fromMap(Map<String, dynamic> map) {
    return PubResOrderBookDepthList(
      symbol: map['symbol'],
      orderType: map['orderType'],
      price: map['price'],
      quantity: map['quantity'],
      total: map['total'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResOrderBookDepthList.fromJson(String source) =>
      PubResOrderBookDepthList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PubResOrderBookDepthList(symbol: $symbol, orderType: $orderType, price: $price, quantity: $quantity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResOrderBookDepthList &&
        other.symbol == symbol &&
        other.orderType == orderType &&
        other.price == price &&
        other.quantity == quantity &&
        other.total == total;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        orderType.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        total.hashCode;
  }
}
