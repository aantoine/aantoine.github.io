import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'planning_voting_ticket_state.dart';

class PlanningVotingTicketCubit extends Cubit<PlanningVotingTicketState> {
  final PlanningSessionRepository _sessionRepository;
  final Table table;

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  PlanningVotingTicketCubit(
    this._sessionRepository,
    this.table,
  ) : super(PlanningVotingTicketState()) {
    _sessionRepository.sessionState(table).listen((sessionState) {
      Ticket? currentTicket;
      if (sessionState.currentTicketId != null) {
        currentTicket =
            sessionState.tickets.firstWhere((t) => t.id == sessionState.currentTicketId);
      }
      emit(PlanningVotingTicketState(current: currentTicket));
    }).addTo(_compositeSubscription);
  }

  @override
  Future<void> close() {
    _compositeSubscription.cancel();
    return super.close();
  }
}
