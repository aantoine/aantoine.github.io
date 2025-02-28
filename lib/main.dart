// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:developer' as dev;

import 'package:card/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'locator.dart' as di;
import 'presentation/style/palette.dart';
import 'router.dart';

void main() async {
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // This is where you add objects that you want to have available
      // throughout your game.
      //
      // Every widget in the game can access these objects by calling
      // `context.watch()` or `context.read()`.
      // See `lib/main_menu/main_menu_screen.dart` for example usage.
      providers: [
        Provider(create: (context) => Palette()),
      ],
      child: Builder(builder: (context) {
        final palette = context.watch<Palette>();

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Poker Planning',
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: palette.primary,
              surface: palette.surface,
            ),
            useMaterial3: true,
          ).copyWith(
            // Make buttons more fun.
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: palette.primaryContainer,
                textStyle: TextStyle(
                  color: palette.onPrimaryContainer,
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                textStyle: TextStyle(
                  color: palette.onPrimaryContainer,
                ),
                iconColor: palette.onSurface,
              ),
            ),
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: WidgetStatePropertyAll(palette.primary),
              thickness: WidgetStatePropertyAll(2),
            )
          ),
          routerConfig: router,
        );
      }),
    );
  }
}
