import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planning_card_deck_state.dart';

class PlanningCardDeckCubit extends Cubit<PlanningCardDeckState> {
  final PlanningSessionRepository _sessionRepository;
  final Table table;

  PlanningCardDeckCubit(
    this._sessionRepository,
    this.table,
  ) : super(PlanningCardDeckState());

  void selectCard(String value) {
    emit(PlanningCardDeckState(selected: value));
    _sessionRepository.selectCardForTable(table, value);
  }

  void deselectCard() {
    emit(PlanningCardDeckState());
    _sessionRepository.selectCardForTable(table, null);
  }
}
