import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'planning_session_state.dart';

class PlanningSessionCubit extends Cubit<PlanningSessionState> {
  final TableRepository _tablesRepository;
  final PlanningSessionRepository _sessionRepository;
  final UserRepository _userRepository;

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  PlanningSessionCubit(
    this._tablesRepository,
    this._sessionRepository,
    this._userRepository,
  ) : super(Loading());

  void initialLoad(Table table) async {
    var tableStream = _tablesRepository.tableState(table);
    var sessionStream = _sessionRepository.sessionState(table);

    final user = await _userRepository.getCurrentUser();

    Rx.combineLatest2(
      tableStream,
      sessionStream,
      (table, session) => (table, session),
    ).listen(
      (data) {
        var isHost = table.hostId == user?.id;

        emit(Loaded(
          isHost: isHost,
          showResults: data.$2.showResults,
        ));
      },
    ).addTo(_compositeSubscription);


  }

  void dispose(Table table) {
    _tablesRepository.leaveTable(table);
    _compositeSubscription.cancel();
  }
}
