import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/user/entities/user.dart';

class PlanningSession {
  final List<Ticket> tickets;
  final List<User> users;
  final String? currentTicketId;
  final bool showResults;
  final Map<String, String> votes;

  PlanningSession(
    this.tickets,
    this.currentTicketId,
    this.showResults,
    this.votes,
    this.users,
  );
}
