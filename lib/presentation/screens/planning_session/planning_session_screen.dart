import 'package:card/application/planning/planning_session_cubit.dart';
import 'package:card/domain/tables/entities/table.dart' as e;
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/user_app_bar_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' hide Level;


class PlanningSessionScreen extends StatelessWidget {
  final e.Table table;
  const PlanningSessionScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<PlanningSessionCubit>(),
      child: _PlaySessionScreen(table),
    );
  }

}

class _PlaySessionScreen extends StatefulWidget {
  final e.Table table;
  const _PlaySessionScreen(this.table);

  @override
  State<_PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<_PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  PlanningSessionCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: palette.surfaceContainer,
        foregroundColor: palette.onSurface,
        title: Text(widget.table.name),
        centerTitle: true,
        actions: [
          UserAppBarAction(inSession: true),
        ],
      ),
      body: BlocBuilder<PlanningSessionCubit, PlanningSessionState>(
        builder: (context, state) {
          return Container(

          );
        },
      ),
    );
  }

  @override
  void dispose() {
    cubit?.dispose(widget.table);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PlanningSessionCubit>(context);
    cubit?.initialLoad(widget.table);
  }
}
