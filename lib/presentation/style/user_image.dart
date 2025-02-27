import 'package:card/domain/user/entities/user.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserImage extends StatelessWidget {
  final User? user;

  const UserImage({super.key, this.user});
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: palette.secondaryContainer,
      ),
      child: user != null
          ? Text(
        user!.name.substring(0, 2).toUpperCase(),
        style: TextStyle(
          color: palette.onSecondaryContainer,
        ),
        textAlign: TextAlign.center,
      )
          : Icon(
        Icons.account_circle,
        color: palette.onSecondaryContainer,
        size: 36,
      ),
    );
  }

}