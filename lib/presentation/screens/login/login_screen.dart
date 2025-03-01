// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/application/login/login_cubit.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return BlocProvider(
      create: (_) => di.locator<LoginCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginCubit, LoginState>(
            listener: (_, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ocurrió un error'),
                  ),
                );
              } else if (state is LoadedState) {
                GoRouter.of(context).pushReplacement('/main');
              }
            },
            child: Scaffold(
              backgroundColor: palette.backgroundMain,
              body: ResponsiveScreen(
                squarishMainArea: Center(
                  child: Text(
                    'Poker Planning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 55,
                      color: palette.onSurface,
                    ),
                  ),
                ),
                rectangularMenuArea: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<LoginCubit>(context).login();
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(color: palette.onPrimaryContainer),
                      ),
                    ),
                    _gap,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static const _gap = SizedBox(height: 12);
}
