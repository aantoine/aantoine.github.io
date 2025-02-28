
import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/tables/entities/table.dart';

abstract class PlanningSessionRepository {
  Stream<PlanningSession> sessionState(Table table);

  void selectCardForTable(Table table, String? cardValue);
  void revealVotesForTable(Table table);
  void nextPlanningInTable(Table table);

  void addNewTicket(Table table, String ticketName);
  void deleteTicket(Table table, String ticketId);
  void startVoting(Table table, String ticketId);
  void updateTicketResult(Table table, String ticketId, String result);
}