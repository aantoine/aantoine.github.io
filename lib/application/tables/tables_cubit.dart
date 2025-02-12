
import 'dart:async';

import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tables_state.dart';

class TablesCubit extends Cubit<TablesState> {
  final TableRepository _tablesRepository;
  StreamSubscription? _subscription;

  TablesCubit(this._tablesRepository) : super(Loading());

  void initialLoad() async {
    _subscription = _tablesRepository.getCurrentTables().listen((tables) {
      emit(Loaded(tables));
    });
  }

  void onStop() {
    _subscription?.cancel();
  }

  Future<void> createTable() async {
    var table = await _tablesRepository.createTable();
    emit(Joined(table));
  }

  Future<void> joinTable(Table table) async {
    await _tablesRepository.joinTable(table);
    emit(Joined(table));
  }

}