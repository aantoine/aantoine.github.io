import 'package:card/application/splash/splash_cubit.dart';
import 'package:card/application/splash/splash_state.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<SplashCubit>(),
      child: _SplashScreen(),
    );
  }

}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<_SplashScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashCubit>(context).initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is Loaded) {
            if (state.currentUser != null) {
              GoRouter.of(context).pushReplacement('/main');
            } else {
              GoRouter.of(context).pushReplacement('/login');
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
