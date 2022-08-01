import 'dart:convert';

import 'package:bitsumb2/app/modules/controllers/bithumb/vo/PubResOrderBookDepthContent.dart';

// 호가 orderbook
class PubResOrderBookDepth {
  String? type;
  late PubResOrderBookDepthContent content;
  PubResOrderBookDepth({
    this.type,
    required this.content,
  });

  PubResOrderBookDepth copyWith({
    String? type,
    PubResOrderBookDepthContent? content,
  }) {
    return PubResOrderBookDepth(
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

  factory PubResOrderBookDepth.fromMap(Map<String, dynamic> map) {
    return PubResOrderBookDepth(
      type: map['type'],
      content: PubResOrderBookDepthContent.fromMap(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PubResOrderBookDepth.fromJson(String source) =>
      PubResOrderBookDepth.fromMap(json.decode(source));

  @override
  String toString() => 'PubResOrderBookDepth(type: $type, content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PubResOrderBookDepth &&
        other.type == type &&
        other.content == content;
  }

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}
