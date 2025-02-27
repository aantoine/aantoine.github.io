import 'package:card/application/planning_card_deck/planning_card_deck_cubit.dart';
import 'package:card/presentation/style/bloc_planning_session_builder.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/planning/planning_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PlanningCardDeck extends StatelessWidget {
  const PlanningCardDeck({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return PlanningBlocProvider<PlanningCardDeckCubit>(
      child: SizedBox(
        height: 122,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlanningCard(value: "1"),
                  PlanningCard(value: "2"),
                  PlanningCard(value: "3"),
                  PlanningCard(value: "5"),
                  PlanningCard(value: "8"),
                  PlanningCard(value: "13"),
                  PlanningCard(value: "21"),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(bottom: 104),
              child: Text(
                "Choose your card",
                style: TextStyle(
                  color: palette.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}