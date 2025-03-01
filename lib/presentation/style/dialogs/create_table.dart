import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTableDialog extends StatefulWidget {
  const CreateTableDialog({super.key});

  @override
  State<CreateTableDialog> createState() => _CreateTableDialogState();
}

class _CreateTableDialogState extends State<CreateTableDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final elementWidth = 500.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: palette.surfaceOutline),
      ),
      backgroundColor: palette.surfaceContainerHigh,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create a room to start voting",
                style: TextStyle(color: palette.onSurface, fontSize: 18),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: elementWidth,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: palette.primary),
                    ),
                    labelText: 'Room name',
                  ),
                  style: TextStyle(color: palette.onSurface, fontSize: 14),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: elementWidth,
                height: 36,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _controller.text),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.hovered)) {
                          return palette.primaryContainer.withOpacity(0.8);
                        }
                        return palette
                            .primaryContainer; // Use the component's default.
                      },
                    ),
                    shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
                          (Set<WidgetState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ); // Use the component's default.
                      },
                    ),
                  ),
                  child: Text(
                    "CREATE ROOM",
                    style: TextStyle(color: palette.onPrimaryContainer, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}