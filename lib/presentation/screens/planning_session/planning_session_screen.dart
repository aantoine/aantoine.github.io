import 'package:card/application/planning_session/planning_session_cubit.dart';
import 'package:card/application/planning_table/models/user_with_vote_view_model.dart';
import 'package:card/application/planning_table/planning_table_cubit.dart';
import 'package:card/domain/tables/entities/table.dart' as e;
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/bloc_planning_session_builder.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/planning/planning_card_deck.dart';
import 'package:card/presentation/style/planning/planning_table.dart';
import 'package:card/presentation/style/planning/voting_ticket.dart';
import 'package:card/presentation/style/user_app_bar_action.dart';
import 'package:card/presentation/style/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

class PlanningSessionScreen extends StatelessWidget {
  final e.Table table;
  const PlanningSessionScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => table,
      child: BlocProvider(
        create: (_) => di.locator<PlanningSessionCubit>(),
        child: _PlaySessionScreen(table),
      ),
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
          if (state is Loaded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: UserListWidget(),
                ),
                Flexible(
                  flex: 3,
                  child: MainBoardWidget(showResults: state.showResults),
                ),
                Flexible(
                  flex: 1,
                  child: TicketListWidget(),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
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

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
    );
  }
}

class MainBoardWidget extends StatelessWidget {
  final bool showResults;
  const MainBoardWidget({super.key, required this.showResults});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanningSessionCubit, PlanningSessionState>(
        builder: (context, state) {
      return Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Voting Ticket
            const VotingTicketWidget(),
            // Table
            const PlanningTable(),
            // Cards
            if (!showResults) const PlanningCardDeck(),
            //TODO: results widget?
            if (showResults) const SizedBox(height: 122),
          ],
        ),
      );
    });
  }
}

class TicketListWidget extends StatelessWidget {
  const TicketListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
