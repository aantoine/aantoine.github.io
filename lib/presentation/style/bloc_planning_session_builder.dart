import 'package:card/domain/tables/entities/table.dart' as e;
import 'package:card/locator.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanningBlocBuilderProvider<B extends BlocBase<S>, S> extends StatelessWidget {
  final BlocWidgetBuilder<S> builder;
  const PlanningBlocBuilderProvider({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final table = context.watch<e.Table>();
    return BlocProvider<B>(
      create: (_) => di.locator<B>(param1: table),
      child: BlocBuilder<B, S>(
        builder: builder,
      ),
    );
  }
}

class PlanningBlocProvider<B extends StateStreamableSource<Object?>> extends StatelessWidget {
  final Widget child;
  const PlanningBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final table = context.watch<e.Table>();
    return BlocProvider<B>(
      create: (_) => di.locator<B>(param1: table),
      child: child,
    );
  }
}

