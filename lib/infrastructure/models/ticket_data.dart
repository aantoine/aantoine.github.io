import 'package:card/domain/planning_session/entities/ticket.dart';

extension TicketData on Ticket {
  Map<String, dynamic> toJson() {
    var json = {
      'id': id,
      'name': name,
      'resolved': resolved,
      'votes': votes,
    };
    var result = this.result;
    if (result != null) {
      json.addAll({'result': result});
    }
    return json;
  }

  static Ticket fromJson(Map<String, dynamic> json) {
    return Ticket(
      json['id'] as String,
      json['name'] as String,
      resolved: json['resolved'] as bool,
      votes: json['votes'] as List<String>,
      result: json['result'] as String?,
    );
  }
}