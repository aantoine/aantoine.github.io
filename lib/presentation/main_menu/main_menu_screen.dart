import 'dart:math';

import 'package:card/application/tables/tables_cubit.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/dialogs/create_table.dart';
import 'package:card/presentation/style/mouse_region_card.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/table_card/table_card.dart';
import 'package:card/presentation/style/table_card/table_card_add.dart';
import 'package:card/presentation/style/user_app_bar_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    cubit?.onStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const padding = 30.0;
    const columnWidth = 300.0;
    final availableWidth = MediaQuery.of(context).size.width;
    final columns = ((availableWidth - (padding * 2)) / columnWidth).floor();
    final totalWidth =
        (columns * columnWidth) + (padding * 2); // columns + padding
    final spaces = max(columns - 1, 0); // spaces between columns
    final maxSpacing =
        max((availableWidth - totalWidth) / spaces, 0).toDouble();

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: palette.surfaceContainer,
        foregroundColor: palette.onSurface,
        title: Text("Poker Planning"),
        leading: Icon(Icons.plumbing),
        centerTitle: false,
        actions: [
          UserAppBarAction(),
        ],
      ),
      body: BlocConsumer<TablesCubit, TablesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is Loaded) {
            var tables = state.tables.map((table) {
              return MouseRegionContainer(
                onTap: () {
                  //TODO: add cubit call to join table
                },
                child: TableCard(
                  palette: palette,
                  columnWidth: columnWidth,
                  table: table,
                ),
              );
            }).toList();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
              child: GridView.count(
                crossAxisCount: columns,
                padding: const EdgeInsets.all(padding),
                crossAxisSpacing: min(maxSpacing, 20),
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
                children: [
                  ...tables,
                  MouseRegionContainer(
                    onTap: () async {
                      String? tableName = await showDialog(
                        context: context,
                        builder: (_) => Builder(
                          builder: (_) => const CreateTableDialog(),
                        ),
                        barrierDismissible: true,
                      );
                      if (!context.mounted || tableName == null) return;
                      BlocProvider.of<TablesCubit>(context)
                          .createTable(tableName);
                    },
                    child: TableCardAdd(
                      palette: palette,
                      columnWidth: columnWidth,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
