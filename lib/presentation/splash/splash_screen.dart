// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/presentation/style/my_button.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: const Text(
            'Transapp Pocket Planning',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 55,
              height: 1,
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SineButton(
              onPressed: () {
                GoRouter.of(context).go('/login');
              },
              child: const Text('Log in'),
            ),
            _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 12);
}
