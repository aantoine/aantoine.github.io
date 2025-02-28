import 'package:card/application/tickets/models/ticket_view_model.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final PlanningSessionRepository _sessionRepository;
  final Table table;

  TicketsCubit(
    this._sessionRepository,
    this.table,
  ) : super(TicketsState()) {
    _sessionRepository.sessionState(table).listen((sessionState) {
      var tickets = sessionState.tickets.map((ticket) {
        var isActive = ticket.id == sessionState.currentTicketId;
        return TicketViewModel(
          ticket,
          isActive,
          ticket.resolved ? ticket.votes.length : sessionState.votes.length,
          ticket.votes.join(" - "),
          ticket.result ?? "",
        );
      }).toList();
      emit(TicketsState(tickets: tickets, adding: state.adding));
    });
  }

  void addTicket(String ticketName) {
    _sessionRepository.addNewTicket(table, ticketName);
  }

  void deleteTicket(String id) {
    _sessionRepository.deleteTicket(table, id);
  }

  void startVoting(String id) {
    _sessionRepository.startVoting(table, id);
  }

  void updateTicketResult(String id, String result) {
    _sessionRepository.updateTicketResult(table, id, result);
  }

  /*void startAddingTicket() {
    emit(TicketsState(tickets: state.tickets, adding: true));
  }

  void stopAddingTicket() {
    emit(TicketsState(tickets: state.tickets, adding: false));
  }*/
}
