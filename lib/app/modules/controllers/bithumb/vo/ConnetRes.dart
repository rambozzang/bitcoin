import 'dart:convert';

class ConnectRes {
  String? status;
  String? resmsg;
  ConnectRes({
    this.status,
    this.resmsg,
  });

  ConnectRes copyWith({
    String? status,
    String? resmsg,
  }) {
    return ConnectRes(
      status: status ?? this.status,
      resmsg: resmsg ?? this.resmsg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'resmsg': resmsg,
    };
  }

  factory ConnectRes.fromMap(Map<String, dynamic> map) {
    return ConnectRes(
      status: map['status'],
      resmsg: map['resmsg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectRes.fromJson(String source) =>
      ConnectRes.fromMap(json.decode(source));

  @override
  String toString() => 'ConnectRes(status: $status, resmsg: $resmsg)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectRes &&
        other.status == status &&
        other.resmsg == resmsg;
  }

  @override
  int get hashCode => status.hashCode ^ resmsg.hashCode;
}
