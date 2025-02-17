import 'dart:math';

import 'package:flutter/material.dart';

class MouseRegionContainer extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  const MouseRegionContainer(
      {super.key, required this.child, required this.onTap});

  @override
  State<MouseRegionContainer> createState() => _MouseRegionContainerState();
}

class _MouseRegionContainerState extends State<MouseRegionContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (event) {
          _controller.repeat();
        },
        onExit: (event) {
          _controller.stop(canceled: false);
        },
        cursor: SystemMouseCursors.click,
        child: RotationTransition(
          turns: _controller.drive(const _MySineTween(0.001)),
          child: widget.child,
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
