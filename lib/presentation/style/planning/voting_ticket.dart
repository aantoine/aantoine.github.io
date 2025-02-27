import 'package:card/application/planning_voting_ticket/planning_voting_ticket_cubit.dart';
import 'package:card/presentation/style/bloc_planning_session_builder.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotingTicketWidget extends StatelessWidget {
  const VotingTicketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return PlanningBlocBuilderProvider<PlanningVotingTicketCubit,
        PlanningVotingTicketState>(
      builder: (context, state) {
        var currentTicket = state.current;
        Widget votingText;
        if (currentTicket != null) {
          votingText = Text.rich(
            TextSpan(
              text: "Voting: ",
              style: TextStyle(
                color: palette.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: currentTicket.name,
                  style: TextStyle(
                    color: palette.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        } else {
          votingText = Text(
            "The host is selecting a ticket to start the voting",
            style: TextStyle(
              color: palette.onSurface,
              fontSize: 14,
            ),
          );
        }

        return Card(
          color: palette.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // if you need this
            side: BorderSide(
              color: palette.surfaceOutline,
              width: 1,
            ),
          ),
          child: Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: votingText,
          ),
        );
      },
    );
  }
}