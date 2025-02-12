part of 'tables_cubit.dart';

abstract class TablesState {}

class Loading extends TablesState {}
class Loaded extends TablesState {
  final List<Table> tables;

  Loaded(this.tables);
}

class Joined extends TablesState {
  final Table table;

  Joined(this.table);
}