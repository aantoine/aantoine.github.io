import 'package:card/application/tickets/tickets_cubit.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTicketWidget extends StatefulWidget {
  const AddTicketWidget({super.key});

  @override
  State<AddTicketWidget> createState() => _AddTicketWidgetState();
}

class _AddTicketWidgetState extends State<AddTicketWidget> {
  var hovering = false;
  var adding = false;
  late TextEditingController _controller;
  late FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    onSubmit() {
      BlocProvider.of<TicketsCubit>(context).addTicket(_controller.text);
      _controller.clear();
      _nameFocusNode.requestFocus();
    }
    final addingWidget = Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add New Ticket",
            style: TextStyle(
              fontSize: 16,
              color: palette.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            autofocus: true,
            controller: _controller,
            focusNode: _nameFocusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: palette.primary),
              ),
              labelText: 'Name',
            ),
            style: TextStyle(color: palette.onSurface, fontSize: 14),
            onSubmitted: (value) {
              onSubmit();
            },
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      adding = false;
                    });
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 14,
                      color: palette.onSurface,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: onSubmit,
                  label: Text("ADD"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final notAddingWidget = SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8),
          Icon(
            Icons.add,
            size: 24,
            color: palette.onSurface,
          ),
          SizedBox(width: 8),
          Text(
            "ADD TICKET",
            style: TextStyle(
              color: palette.onSurface,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );

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
      child: Card(
        color: palette.surfaceContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: hovering || adding
              ? BorderSide(color: palette.surfaceOutline)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: !adding
              ? () {
                  setState(() {
                    adding = true;
                  });
                }
              : null,
          splashColor: palette.primary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            alignment: Alignment.center,
            child: adding ? addingWidget : notAddingWidget,
          ),
        ),
      ),
    );
  }
}
