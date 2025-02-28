import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planning_card_deck_state.dart';

class PlanningCardDeckCubit extends Cubit<PlanningCardDeckState> {
  final PlanningSessionRepository _sessionRepository;
  final UserRepository _userRepository;
  final Table table;

  PlanningCardDeckCubit(
    this._sessionRepository,
    this._userRepository,
    this.table,
  ) : super(PlanningCardDeckState()) {
    _userRepository.getCurrentUser().then((user) {
      _sessionRepository.sessionState(table).listen((state) {
        if (user != null) {
          var selected = state.votes[user.id];
          emit(PlanningCardDeckState(selected: selected));
        }
      });
    });
  }

  void selectCard(String value) {
    emit(PlanningCardDeckState(selected: value));
    _sessionRepository.selectCardForTable(table, value);
  }

  void deselectCard() {
    emit(PlanningCardDeckState());
    _sessionRepository.selectCardForTable(table, null);
  }
}
