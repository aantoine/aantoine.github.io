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
    _persistenceSource.setSession(
      table,
      PlanningSession(
        tickets,
        state.currentTicketId,
        true,
        state.votes,
        state.users,
      ),
    );
  }

  @override
  void nextPlanningInTable(Table table) async {
    var state = await _persistenceSource.sessionStateFor(table).first;

    String? nextTicketId;
    var pending = state.tickets.where((ticket) {
      return !ticket.resolved;
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
        state.users,
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
    var newTicket = Ticket(id, ticketName);
    var currentState = await _persistenceSource.sessionStateFor(table).first;

    var currentId = currentState.currentTicketId;
    final pending = currentState.tickets.where((ticket) {
      return !ticket.resolved;
    }).toList();
    if (pending.isEmpty) {
      currentId = id;
    }

    _persistenceSource.setSession(
      table,
      PlanningSession(
        [...currentState.tickets, newTicket],
        currentId,
        currentState.showResults,
        currentState.votes,
        currentState.users,
      ),
    );
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

    var currentId =
        isCurrent ? pending.firstOrNull?.id : currentState.currentTicketId;
    var votes = isCurrent ? HashMap<String, String>() : currentState.votes;
    var showResults = isCurrent ? false : currentState.showResults;

    _persistenceSource.setSession(
      table,
      PlanningSession(
        updatedList,
        currentId,
        showResults,
        votes,
        currentState.users,
      ),
    );
  }

  @override
  void startVoting(Table table, String ticketId) async {
    var currentState = await _persistenceSource.sessionStateFor(table).first;

    _persistenceSource.setSession(
      table,
      PlanningSession(
        currentState.tickets,
        ticketId,
        false,
        HashMap(),
        currentState.users,
      ),
    );
  }

  @override
  void updateTicketResult(Table table, String ticketId, String result) async {
    var currentState = await _persistenceSource.sessionStateFor(table).first;
    final tickets = currentState.tickets.map((ticket) {
      if (ticket.id == ticketId) {
        return Ticket(
          ticketId,
          ticket.name,
          resolved: ticket.resolved,
          votes: ticket.votes,
          result: result,
        );
      }
      return ticket;
    }).toList();

    _persistenceSource.setSession(
      table,
      PlanningSession(
        tickets,
        currentState.currentTicketId,
        currentState.showResults,
        currentState.votes,
        currentState.users,
      ),
    );
  }
}
