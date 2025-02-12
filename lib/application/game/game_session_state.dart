part of 'game_session_cubit.dart';

abstract class GameSessionState {}

class Loading extends GameSessionState {}
class Loaded extends GameSessionState {
  final Table table;

  Loaded(this.table);
}
