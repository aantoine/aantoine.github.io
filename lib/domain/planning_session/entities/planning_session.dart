import 'package:card/domain/planning_session/entities/ticket.dart';

class PlanningSession {
  final List<Ticket> tickets;
  final String? currentTicketId;
  final bool showResults;
  final Map<String, String> votes;

  PlanningSession(
    this.tickets,
    this.currentTicketId,
    this.showResults,
    this.votes,
  );
}
