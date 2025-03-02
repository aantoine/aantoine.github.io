import 'package:card/application/tickets/models/ticket_view_model.dart';
import 'package:card/application/tickets/tickets_cubit.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/ticket/delete_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketCard extends StatefulWidget {
  final TicketViewModel viewModel;
  final bool isHost;

  const TicketCard({super.key, required this.viewModel, required this.isHost});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.viewModel.result);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    _controller.text = widget.viewModel.result;
    return Card(
      color: palette.surfaceContainer,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: widget.viewModel.isActiveTicket
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
                    color: widget.viewModel.isActiveTicket
                        ? palette.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: widget.viewModel.isActiveTicket
                        ? null
                        : Border.all(color: palette.surfaceOutline),
                  ),
                  child: Text(
                    widget.viewModel.ticket.resolved ? "Revealed" : "Pending",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !widget.viewModel.isActiveTicket
                          ? palette.onPrimaryContainer
                          : palette.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Votes: ${widget.viewModel.totalVotes}",
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.onSurface,
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  height: 40,
                )),
                if (widget.isHost) DeleteButton(id: widget.viewModel.ticket.id),
              ],
            ),
            SizedBox(height: 8),
            // Name
            Text(
              widget.viewModel.ticket.name,
              style: TextStyle(
                fontSize: 14,
                color: palette.onSurface,
              ),
            ),
            // Action button (reset, start) - result
            SizedBox(height: 12),
            Row(
              children: [
                widget.viewModel.isActiveTicket ||
                        (widget.viewModel.ticket.result != null)
                    ? Text(
                        "Result:  ${widget.viewModel.parsedVotes}",
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : widget.isHost
                        ? OutlinedButton.icon(
                            onPressed: () {
                              BlocProvider.of<TicketsCubit>(context)
                                  .startVoting(widget.viewModel.ticket.id);
                            },
                            label: Text(
                              "START VOTING",
                              style: TextStyle(
                                fontSize: 14,
                                color: palette.onSurface,
                              ),
                            ),
                            icon: Icon(Icons.play_arrow),
                          )
                        : Container(),
                Expanded(child: SizedBox.shrink()),
                SizedBox(
                  width: 40,
                  height: 32,
                  child: TextField(
                    enabled: widget.viewModel.ticket.resolved && widget.isHost,
                    textAlign: TextAlign.center,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: palette.primary),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 2,
                        bottom: 40 / 2,
                      ),
                    ),
                    style: TextStyle(color: palette.onSurface, fontSize: 12),
                    onSubmitted: (value) {
                      BlocProvider.of<TicketsCubit>(context).updateTicketResult(
                          widget.viewModel.ticket.id, value);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
