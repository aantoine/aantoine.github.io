import 'package:card/application/tickets/models/ticket_view_model.dart';
import 'package:card/application/tickets/tickets_cubit.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/ticket/delete_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketCard extends StatelessWidget {
  final TicketViewModel viewModel;

  const TicketCard({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Card(
      color: palette.surfaceContainer,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: viewModel.isActiveTicket
            ? BorderSide(color: palette.primary)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status (pending/revealed) - votes - delete
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: viewModel.isActiveTicket
                        ? palette.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: viewModel.isActiveTicket
                        ? null
                        : Border.all(color: palette.surfaceOutline),
                  ),
                  child: Text(
                    viewModel.ticket.revealed ? "Revealed" : "Pending",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !viewModel.isActiveTicket
                          ? palette.onPrimaryContainer
                          : palette.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Votes: ${viewModel.votes}",
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.onSurface,
                  ),
                ),
                Expanded(child: SizedBox.shrink()),
                DeleteButton(id: viewModel.ticket.id),
              ],
            ),
            SizedBox(height: 8),
            // Name
            Text(
              viewModel.ticket.name,
              style: TextStyle(
                fontSize: 14,
                color: palette.onSurface,
              ),
            ),
            // Action button (reset, start) - result
            SizedBox(height: 12),
            viewModel.isActiveTicket || (viewModel.ticket.result != null)
                ? Text(
                    "Result:  ${viewModel.ticket.result ?? "-"}",
                    style: TextStyle(
                      fontSize: 14,
                      color: palette.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () {
                      BlocProvider.of<TicketsCubit>(context)
                          .startVoting(viewModel.ticket.id);
                    },
                    label: Text(
                      "START VOTING",
                      style: TextStyle(
                        fontSize: 14,
                        color: palette.onSurface,
                      ),
                    ),
                    icon: Icon(Icons.play_arrow),
                  ),
          ],
        ),
      ),
    );
  }
}
