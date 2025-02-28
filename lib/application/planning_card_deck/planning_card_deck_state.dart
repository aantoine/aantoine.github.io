part of 'planning_card_deck_cubit.dart';

class PlanningCardDeckState extends Equatable {
  final String? selected;

  const PlanningCardDeckState({this.selected});

  @override
  List<Object?> get props => [selected];
}
