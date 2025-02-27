part of 'planning_session_cubit.dart';

abstract class PlanningSessionState extends Equatable {}

class Loading extends PlanningSessionState {
  @override
  List<Object?> get props => [];
}

class Loaded extends PlanningSessionState {
  final bool isHost;
  final bool showResults;

  Loaded({
    required this.isHost,
    required this.showResults,
  });

  @override
  List<Object?> get props => [isHost, showResults];
}
