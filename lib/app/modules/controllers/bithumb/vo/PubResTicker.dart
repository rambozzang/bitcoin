import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResTickerContent.dart';

// 현재가 ticker
class PubResTicker {
  String? type; // 구구독 메세지 종류 ticker
  late PubResTickerContent content; //
  PubResTicker({
    this.type,
    required this.content,
  });

  PubResTicker copyWith({
    String? type,
    PubResTickerContent? content,
  }) {
    return PubResTicker(
      type: type ?? this.type,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content.toMap(),
    };
  }

  factory PubResTicker.fromMap(Map<String, dynamic> map) {
    return PubResTicker(
      type: map['type'],
      content: PubResTickerContent.fromMap(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResTicker.fromJson(String source) =>
      PubResTicker.fromMap(json.decode(source));

  @override
  String toString() => 'PubResTicker(type: $type, content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResTicker &&
        other.type == type &&
        other.content == content;
  }

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}
