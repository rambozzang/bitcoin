import 'dart:convert';

class ReqTicketVo {
  String? ticket;
  ReqTicketVo({
    this.ticket,
  });

  ReqTicketVo copyWith({
    String? ticker,
  }) {
    return ReqTicketVo(
      ticket: ticket ?? this.ticket,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticket': ticket,
    };
  }

  factory ReqTicketVo.fromMap(Map<String, dynamic> map) {
    return ReqTicketVo(
      ticket: map['ticket'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReqTicketVo.fromJson(String source) =>
      ReqTicketVo.fromMap(json.decode(source));

  @override
  String toString() => 'ReqTicketVo(ticker: $ticket)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReqTicketVo && other.ticket == ticket;
  }

  @override
  int get hashCode => ticket.hashCode;
}
