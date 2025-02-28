// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';
import 'package:card/presentation/screens/login/login_screen.dart';
import 'package:card/presentation/screens/main_menu/main_menu_screen.dart';
import 'package:card/presentation/style/my_transition.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/planning_session/planning_session_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      //builder: (context, state) => const SplashScreen(key: Key('splash')),
      builder: (context, state) => PlanningSessionScreen(
        key: Key('splash'),
        table: DummyPersistenceSource.dummyTestTable,
      ),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginScreen(key: Key('login')),
        ),
        GoRoute(
          path: 'main',
          builder: (context, state) => const MainMenuScreen(key: Key('main')),
        ),
        GoRoute(
          path: 'table',
          redirect: (context, state) {
            if (state.extra == null) {
              return '/';
            }
            return null;
          },
          pageBuilder: (context, state) {
            var table = state.extra as Table;
            return buildMyTransition<void>(
              key: const ValueKey('play'),
              color: context.watch<Palette>().primary,
              child: PlanningSessionScreen(
                key: Key('planning session'),
                table: table,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
