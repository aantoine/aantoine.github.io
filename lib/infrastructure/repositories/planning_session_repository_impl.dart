import 'dart:collection';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
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
    var result = state.votes.values.fold(0, (acc, value) => acc + int.parse(value)) / state.votes.length;
    var tickets = state.tickets.map((ticket) {
      if (ticket.id == state.currentTicketId) {
        return Ticket(ticket.id, ticket.name, true, result.toString(), state.votes.length);
      }
      return ticket;
    }).toList();
    _persistenceSource.setSession(
      table,
      PlanningSession(
        tickets,
        state.currentTicketId,
        true,
        state.votes,
      ),
    );
  }

  @override
  void nextPlanningInTable(Table table) async {
    var state = await _persistenceSource.sessionStateFor(table).first;

    String? nextTicketId;
    var pending = state.tickets.where((ticket) {
      return !ticket.revealed;
    }).toList();
    if (pending.isNotEmpty) {
      nextTicketId = pending.first.id;
    }

    _persistenceSource.setSession(
      table,
      PlanningSession(
        state.tickets,
        nextTicketId,
        false,
        HashMap(),
      ),
    );
  }

  @override
  void selectCardForTable(Table table, String? cardValue) async {
    final user = await _authenticationSource.getUser();
    var currentState = await _persistenceSource.sessionStateFor(table).first;
    if (user != null) {
      if (cardValue != null) {
        currentState.votes.update(
          user.id,
          (value) => cardValue,
          ifAbsent: () => cardValue,
        );
      } else {
        currentState.votes.remove(user.id);
      }

      _persistenceSource.setSession(
        table,
        currentState,
      );
    }
  }

  @override
  void addNewTicket(Table table, String ticketName) async {
    var id = Uuid().v4();
    var newTicket = Ticket(id, ticketName, false, null, 0);
    var currentState = await _persistenceSource.sessionStateFor(table).first;

    var currentId = currentState.currentTicketId;
    if (currentState.tickets.isEmpty) {
      currentId = id;
    }

    _persistenceSource.setSession(
      table,
      PlanningSession(
        [...currentState.tickets, newTicket],
        currentId,
        currentState.showResults,
        currentState.votes,
      ),
    );
  }

  @override
  void deleteTicket(Table table, String ticketId) async {
    var currentState = await _persistenceSource.sessionStateFor(table).first;
    var updatedList = currentState.tickets.where((ticket) => ticket.id != ticketId).toList();
    final isCurrent = ticketId == currentState.currentTicketId;
    final pending = currentState.tickets.where((ticket) {
      return !ticket.revealed;
    }).toList();

    var currentId = isCurrent ? pending.firstOrNull?.id : currentState.currentTicketId;
    var votes = isCurrent ? HashMap<String, String>() : currentState.votes;
    var showResults = isCurrent ? false : currentState.showResults;

    _persistenceSource.setSession(
      table,
      PlanningSession(
        updatedList,
        currentId,
        showResults,
        votes,
      ),
    );
  }

  @override
  void startVoting(Table table, String id) async {
    var currentState = await _persistenceSource.sessionStateFor(table).first;

    _persistenceSource.setSession(
      table,
      PlanningSession(
        currentState.tickets,
        id,
        false,
        HashMap(),
      ),
    );
  }
}
