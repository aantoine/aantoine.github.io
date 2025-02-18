part of 'planning_session_cubit.dart';

abstract class PlanningSessionState {}

class Loading extends PlanningSessionState {}
class Loaded extends PlanningSessionState {
  final Table table;
  final PlanningSession sessionState;

  Loaded(this.table, this.sessionState);
}
