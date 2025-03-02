import 'dart:collection';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/models/session_state_date.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';
import 'package:uuid/uuid.dart';

class PlanningSessionRepositoryImpl extends PlanningSessionRepository {
  final ExternalPersistenceSource _persistenceSource;
  final AuthenticationSource _authenticationSource;

  PlanningSessionRepositoryImpl(
      this._persistenceSource, this._authenticationSource);

  @override
  Stream<PlanningSession> sessionState(Table table) {
    return _persistenceSource.sessionStateFor(table);
  }

  @override
  void revealVotesForTable(Table table) async {
    var state = await _persistenceSource.sessionStateFor(table).first;
    var popular = HashMap<String, int>();

    for (var vote in state.votes.values) {
      if (!popular.containsKey(vote)) {
        popular[vote] = 1;
      } else {
        popular[vote] = popular[vote]! + 1;
      }
    }

    List<int> sortedValues = popular.values.toList()..sort();
    int popularValue = sortedValues.last;

    List<String> mostPopularValues = [];
    popular.forEach((k, v) {
      if (v == popularValue) {
        mostPopularValues.add(k);
      }
    });

    /*var result =
        state.votes.values.fold(0, (acc, value) => acc + int.parse(value)) /
            state.votes.length;*/
    var result = mostPopularValues.first;
    var votes = state.votes.values.toList();
    var tickets = state.tickets.map((ticket) {
      if (ticket.id == state.currentTicketId) {
        return Ticket(
          ticket.id,
          ticket.name,
          resolved: true,
          result: result,
          votes: votes,
        );
      }
      return ticket;
    }).toList();

    // update state
    await _persistenceSource.updateStateFor(table, SessionStateData(state.currentTicketId, true),);
    await _persistenceSource.updateTicketsFor(table, tickets);

  }

  @override
  void nextPlanningInTable(Table table) async {
    var state = await _persistenceSource.sessionStateFor(table).first;

    String? nextTicketId;
    var pending = state.tickets.where((ticket) {
      return !ticket.resolved;
    }).toList();
    if (pending.isNotEmpty) {
      await _persistenceSource.updateStateFor(table, SessionStateData(nextTicketId, false),);
    }

    // update votes
    await _persistenceSource.clearVotesFor(table);
  }

  @override
  void selectCardForTable(Table table, String? cardValue) async {
    final user = await _authenticationSource.getUser();
    if (user != null) {
      _persistenceSource.updateVotesFor(table, user, cardValue);
    }
  }

  @override
  void addNewTicket(Table table, String ticketName) async {
    var id = Uuid().v4();
    var newTicket = Ticket(id, ticketName);
    var currentState = await _persistenceSource.sessionStateFor(table).first;

    final pending = currentState.tickets.where((ticket) {
      return !ticket.resolved;
    }).toList();
    if (pending.isEmpty) {
      await _persistenceSource.updateStateFor(table, SessionStateData(id, currentState.showResults),);
    }

    var tickets = [...currentState.tickets, newTicket];
    await _persistenceSource.updateTicketsFor(table, tickets);
  }

  @override
  void deleteTicket(Table table, String ticketId) async {
    var currentState = await _persistenceSource.sessionStateFor(table).first;
    var updatedList =
        currentState.tickets.where((ticket) => ticket.id != ticketId).toList();
    final isCurrent = ticketId == currentState.currentTicketId;
    final pending = currentState.tickets.where((ticket) {
      return !ticket.resolved && ticket.id != ticketId;
    }).toList();

    if (isCurrent) {
      await _persistenceSource.clearVotesFor(table);
      await _persistenceSource.updateStateFor(table, SessionStateData(pending.firstOrNull?.id, false),);
    }

    await _persistenceSource.updateTicketsFor(table, updatedList);
  }

  @override
  void startVoting(Table table, String ticketId) async {
    await _persistenceSource.clearVotesFor(table);
    await _persistenceSource.updateStateFor(table, SessionStateData(ticketId, false),);
  }

  @override
  void updateTicketResult(Table table, String ticketId, String result) async {
    // TODO: update tickets
  }
}
