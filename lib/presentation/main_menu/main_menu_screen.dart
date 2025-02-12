
import 'package:card/application/tables/tables_cubit.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/my_button.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<TablesCubit>(),
      child: _MainMenuScreen(),
    );
  }

}

class _MainMenuScreen extends StatefulWidget {
  const _MainMenuScreen();

  @override
  State<_MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<_MainMenuScreen> {

  TablesCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TablesCubit>(context);
    cubit?.initialLoad();
  }

  @override void dispose() {
    cubit?.onStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        // Current Tables
        squarishMainArea: BlocConsumer<TablesCubit, TablesState>(
          listener: (context, state) {
            if (state is Joined) {
              GoRouter.of(context).pushReplacement('/table', extra: state.table);
            }
          },
          builder: (context, state) {
            if (state is Loaded) {
              if (state.tables.isEmpty) {
                return Center(
                  child: Text("No hay mesas disponibles"),
                );
              }
              return Column(
                children: [
                  _gap,
                  Text("Mesas disponibles"),
                  _gap,
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: state.tables.length + 1,
                      itemBuilder: (BuildContext c, int index) {
                        if (index == state.tables.length) {
                          return const SizedBox.shrink();
                        }
                        var table = state.tables[index];
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<TablesCubit>(context).joinTable(table);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: table.name,
                              children: <InlineSpan>[
                                TextSpan(text: "("),
                                TextSpan(text: table.users.length.toString()),
                                TextSpan(text: ")"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        ),

        // Create new table
        rectangularMenuArea: SineButton(
          onPressed: () {
            BlocProvider.of<TablesCubit>(context).createTable();
          },
          child: const Text('Crear mesa'),
        ),
      ),
    );
  }
  static const _gap = SizedBox(height: 12);
}
