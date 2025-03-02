import 'package:card/domain/planning_session/entities/ticket.dart';

class TicketData {
  final List<Ticket> tickets;

  TicketData(this.tickets);

  Map<String, dynamic> toJson() {
    return {
      "tickets": tickets.map((ticket) {
        var json = {
          'id': ticket.id,
          'name': ticket.name,
          'resolved': ticket.resolved,
          'votes': ticket.votes,
        };
        var result = ticket.result;
        if (result != null) {
          json.addAll({'result': result});
        }
        return json;
      }),
    };
  }

  static TicketData fromJson(Map<String, dynamic> json) {
    Iterable rawTickets = json['tickets'] as Iterable? ?? [];
    return TicketData(
      List<Ticket>.from(
        rawTickets.map(
          (model) => Ticket(
            model['id'] as String,
            model['name'] as String,
            resolved: model['resolved'] as bool,
            votes: model['votes'] as List<String>,
            result: model['result'] as String?,
          ),
        ),
      ),
    );
  }
}
