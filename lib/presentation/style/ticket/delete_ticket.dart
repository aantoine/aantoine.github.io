import 'package:card/application/tickets/tickets_cubit.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButton extends StatefulWidget {
  final String id;
  const DeleteButton({super.key, required this.id});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  var hovering = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return MouseRegion(
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
      child: InkWell(
        onTap: () {
          BlocProvider.of<TicketsCubit>(context).deleteTicket(widget.id);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: !hovering ? null : palette.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.delete,
            color: palette.error,
            size: 18,
          ),
        ),
      ),
    );
  }
}
