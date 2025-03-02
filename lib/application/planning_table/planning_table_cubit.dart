import 'package:card/application/planning_table/models/user_with_vote_view_model.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'planning_table_state.dart';

class PlanningTableCubit extends Cubit<PlanningTableState> {
  final PlanningSessionRepository _sessionRepository;
  final UserRepository _userRepository;

  final Table table;
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  PlanningTableCubit(
    this._sessionRepository,
    this._userRepository,
    this.table,
  ) : super(PlanningTableState()) {
    _userRepository.getCurrentUser().then((user) {
      _sessionRepository.sessionState(table).listen(
        (sessionState) {
          final (evenList, oddList) =
              _processUsers(user, sessionState.users, sessionState.votes);

          final readyToReveal = sessionState.users.length == sessionState.votes.length;

          emit(PlanningTableState(
            topList: evenList,
            bottomList: oddList,
            isHost: user?.id == table.hostId,
            revealing: sessionState.showResults,
            readyToReveal: readyToReveal,
          ));
        },
      ).addTo(_compositeSubscription);
    });
  }

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }

  (List<UserWithVoteViewModel>, List<UserWithVoteViewModel>) _processUsers(
    User? user,
    List<User> users,
    Map<String, String> votes,
  ) {
    var mappedUsers = users.map((user) {
      final userVote = votes[user.id];
      return UserWithVoteViewModel(user, userVote);
    }).toList();
    var currentUserViewModel =
        mappedUsers.firstWhere((viewModel) => viewModel.user.id == user?.id);
    var otherUsers = mappedUsers
        .where((viewModel) => viewModel.user.id != user?.id)
        .toList();
    var sortedMappedUsers = [currentUserViewModel, ...otherUsers];

    List<UserWithVoteViewModel> evenList = [];
    List<UserWithVoteViewModel> oddList = [];

    for (final (index, item) in sortedMappedUsers.indexed) {
      if (index % 2 == 0) {
        evenList.add(item);
      } else {
        oddList.add(item);
      }
    }

    return (evenList, oddList);
  }

  void revealTable() {
    _sessionRepository.revealVotesForTable(table);
  }

  void nextPlanning() {
    _sessionRepository.nextPlanningInTable(table);
  }
}
