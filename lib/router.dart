// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/domain/tables/entities/table.dart';
import 'package:card/presentation/login/login_screen.dart';
import 'package:card/presentation/main_menu/main_menu_screen.dart';
import 'package:card/presentation/splash/splash_screen.dart';
import 'package:card/presentation/style/my_transition.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'play_session/play_session_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(key: Key('splash')),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) =>
          const LoginScreen(key: Key('login')),
        ),
        GoRoute(
          path: 'main',
          builder: (context, state) =>
          const MainMenuScreen(key: Key('main')),
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
              color: context.watch<Palette>().backgroundPlaySession,
              child: PlaySessionScreen(
                key: Key('play session'),
                table: table,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
