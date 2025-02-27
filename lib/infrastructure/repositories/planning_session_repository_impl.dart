import 'dart:collection';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';

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
    _persistenceSource.setSession(
      table,
      PlanningSession(
        state.tickets,
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
    final currentIndex = state.tickets
        .indexWhere((ticket) => ticket.id == state.currentTicketId);
    if (currentIndex != -1 && currentIndex < state.tickets.length - 1) {
      final nextIndex = currentIndex + 1;
      nextTicketId = state.tickets[nextIndex].id;
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
}
