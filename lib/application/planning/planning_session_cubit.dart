import 'dart:async';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'planning_session_state.dart';

class PlanningSessionCubit extends Cubit<PlanningSessionState> {
  final TableRepository _tablesRepository;
  final PlanningSessionRepository _sessionRepository;
  StreamSubscription? _subscription;

  PlanningSessionCubit(this._tablesRepository, this._sessionRepository)
      : super(Loading());

  void initialLoad(Table table) async {
    var tableStream = _tablesRepository.tableState(table);
    var sessionStream = _sessionRepository.sessionState(table);

    _subscription = Rx.combineLatest2(
      tableStream,
      sessionStream,
      (table, session) => (table, session),
    ).listen(
      (data) {
        emit(Loaded(data.$1, data.$2));
      },
    );
  }

  void dispose(Table table) {
    _tablesRepository.leaveTable(table);
    _subscription?.cancel();
  }
}
