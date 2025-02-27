part of 'planning_table_cubit.dart';

class PlanningTableState extends Equatable {
  final List<UserWithVoteViewModel> topList;
  final List<UserWithVoteViewModel> bottomList;
  final bool revealing;
  final bool isHost;
  final bool readyToReveal;

  const PlanningTableState({
    this.topList = const [],
    this.bottomList = const [],
    this.revealing = false,
    this.isHost = false,
    this.readyToReveal = false,
  });

  @override
  List<Object?> get props => [
        topList,
        bottomList,
        revealing,
        isHost,
        readyToReveal,
      ];
}
