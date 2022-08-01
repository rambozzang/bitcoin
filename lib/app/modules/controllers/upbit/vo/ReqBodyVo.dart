import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReqBodyVo {
  String? type;
  List<String>? codes;
  ReqBodyVo({
    this.type,
    this.codes,
  });

  ReqBodyVo copyWith({
    String? type,
    List<String>? codes,
  }) {
    return ReqBodyVo(
      type: type ?? this.type,
      codes: codes ?? this.codes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'codes': codes,
    };
  }

  factory ReqBodyVo.fromMap(Map<String, dynamic> map) {
    return ReqBodyVo(
      type: map['type'],
      codes: List<String>.from(map['codes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReqBodyVo.fromJson(String source) =>
      ReqBodyVo.fromMap(json.decode(source));

  @override
  String toString() => 'ReqBodyVo(type: $type, codes: $codes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReqBodyVo &&
        other.type == type &&
        listEquals(other.codes, codes);
  }

  @override
  int get hashCode => type.hashCode ^ codes.hashCode;
}
