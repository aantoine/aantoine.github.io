import 'package:card/application/planning_card_deck/planning_card_deck_cubit.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanningCard extends StatefulWidget {
  final String value;

  const PlanningCard({
    super.key,
    required this.value,
  });

  @override
  State<PlanningCard> createState() => _PlanningCardState();
}

class _PlanningCardState extends State<PlanningCard> {
  var hovering = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return BlocBuilder<PlanningCardDeckCubit, PlanningCardDeckState>(
      buildWhen: (previous, current) {
        return current.selected == widget.value ||
            previous.selected == widget.value;
      },
      builder: (context, state) {
        var isSelected = state.selected == widget.value;
        return AnimatedPadding(
          padding: state.selected == widget.value
              ? EdgeInsets.only(bottom: 16)
              : EdgeInsets.zero,
          duration: Duration(milliseconds: 150),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                hovering = true;
              });
            },
            onExit: (_) {
              setState(() {
                hovering = false;
              });
            },
            child: Card(
              color: isSelected
                  ? palette.primaryContainer
                  : palette.surfaceContainerHigh,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: hovering
                    ? BorderSide(color: palette.primary)
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: () {
                  final bloc = BlocProvider.of<PlanningCardDeckCubit>(context);
                  if (isSelected) {
                    bloc.deselectCard();
                  } else {
                    bloc.selectCard(widget.value);
                  }
                },
                splashColor: palette.primary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 64,
                  alignment: Alignment.center,
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      color:  isSelected
                          ? palette.onPrimaryContainer
                          : palette.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
