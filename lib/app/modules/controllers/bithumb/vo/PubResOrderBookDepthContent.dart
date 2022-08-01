import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResOrderBookDepthList.dart';
import 'package:flutter/foundation.dart';

class PubResOrderBookDepthContent {
  List<PubResOrderBookDepthList>? list; // 코인심볼
  String? datetime; // 건수
  PubResOrderBookDepthContent({
    this.list,
    this.datetime,
  });

  PubResOrderBookDepthContent copyWith({
    List<PubResOrderBookDepthList>? list,
    String? datetime,
  }) {
    return PubResOrderBookDepthContent(
      list: list ?? this.list,
      datetime: datetime ?? this.datetime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'list': list?.map((x) => x.toMap()).toList(),
      'datetime': datetime,
    };
  }

  factory PubResOrderBookDepthContent.fromMap(Map<String, dynamic> map) {
    return PubResOrderBookDepthContent(
      list: map['list'] != null
          ? List<PubResOrderBookDepthList>.from(
              map['list']?.map((x) => PubResOrderBookDepthList.fromMap(x)))
          : null,
      datetime: map['datetime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResOrderBookDepthContent.fromJson(String source) =>
      PubResOrderBookDepthContent.fromMap(json.decode(source));

  @override
  String toString() =>
      'PubResOrderBookDepthContent(list: $list, datetime: $datetime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResOrderBookDepthContent &&
        listEquals(other.list, list) &&
        other.datetime == datetime;
  }

  @override
  int get hashCode => list.hashCode ^ datetime.hashCode;
}
