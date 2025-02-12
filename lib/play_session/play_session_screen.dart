import 'package:card/application/game/game_session_cubit.dart';
import 'package:card/domain/tables/entities/table.dart' as e;
import 'package:card/game_internals/board_state.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/my_button.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import 'board_widget.dart';

class PlaySessionScreen extends StatelessWidget {
  final e.Table table;
  const PlaySessionScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<GameSessionCubit>(),
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

  late final BoardState _boardState;
  GameSessionCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        Provider.value(value: _boardState),
      ],
      child: IgnorePointer(
        // Ignore all input during the celebration animation.
        ignoring: false,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          // The stack is how you layer widgets on top of each other.
          // Here, it is used to overlay the winning confetti animation on top
          // of the game.
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkResponse(
                  onTap: () => GoRouter.of(context).push('/settings'),
                  child: Image.asset(
                    'assets/images/settings.png',
                    semanticLabel: 'Settings',
                  ),
                ),
              ),
              const Spacer(),
              // The actual UI of the game.
              const BoardWidget(),
              const Text('Drag cards to the two areas above.'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SineButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boardState.dispose();
    cubit?.onStop(widget.table);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<GameSessionCubit>(context);
    cubit?.initialLoad(widget.table);
    _boardState = BoardState(onWin: () => {});
  }
}
