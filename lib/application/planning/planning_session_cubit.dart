import 'dart:async';

import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planning_session_state.dart';

class PlanningSessionCubit extends Cubit<PlanningSessionState> {
  final TableRepository _tablesRepository;
  StreamSubscription? _subscription;

  PlanningSessionCubit(this._tablesRepository) : super(Loading());

  void initialLoad(Table table) async {
    _subscription = _tablesRepository.tableState(table).listen((table) {
      emit(Loaded(table));
    });
  }

  void onStop(Table table) {
    _tablesRepository.leaveTable(table);
    _subscription?.cancel();
  }
}