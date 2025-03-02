import 'package:card/application/user/user_cubit.dart';
import 'package:card/locator.dart' as di;
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserAppBarAction extends StatelessWidget {
  final bool inSession;
  const UserAppBarAction({super.key, this.inSession = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<UserCubit>(),
      child: Builder(
        builder: (_) {
          return BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              if (state is LogoutState) {
                GoRouter.of(context).pushReplacement('/login');
              }
            },
            builder: (context, state) {
              return Row(
                children: [
                  if (state is LoadedState) Text(state.user.name),
                  if (state is LoadingState)
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  SizedBox(width: 8),
                  UserMenu(
                    state: state,
                    inSession: inSession,
                  ),
                  SizedBox(width: 12)
                ],
              );
            },
          );
        },
      ),
    );
  }
}

enum MenuEntry { edit, darkMode, observerMode, logout }

class UserMenu extends StatefulWidget {
  final UserState state;
  final bool inSession;

  const UserMenu({super.key, required this.state, required this.inSession});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final state = widget.state;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MenuAnchor(
        childFocusNode: _buttonFocusNode,
        alignmentOffset: Offset(0, 16),
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered)) {
                return palette.surfaceContainerHighest;
              }
              return palette
                  .surfaceContainerHighest; // Use the component's default.
            },
          ),
          alignment: Alignment.bottomRight,
        ),
        menuChildren: <Widget>[
          MenuItemButton(
            onPressed: () => _activate(MenuEntry.edit),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state is LoadedState ? state.user.name : "",
                        style: TextStyle(
                          color: palette.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        state is LoadedState ? state.user.email : "",
                        style: TextStyle(
                          color: palette.onSurface,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  UserImage(
                    user: state is LoadedState ? state.user : null,
                  ),
                ],
              ),
            ),
          ),
          if (widget.inSession)
            Divider(
              color: palette.onSurface,
            ),
          if (widget.inSession)
            MenuItemButton(
              trailingIcon: Icon(
                Icons.self_improvement,
                color: palette.onSurface,
              ),
              //trailingIcon: Switch(value: false, onChanged: (_) {}),
              onPressed: () => _activate(MenuEntry.observerMode),
              child: Text(
                'Observer mode',
                style: TextStyle(
                  color: palette.onSurface,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          Divider(
            color: palette.onSurface,
          ),
          MenuItemButton(
            trailingIcon: Icon(
              Icons.logout,
              color: palette.onSurface,
            ),
            //trailingIcon: Switch(value: false, onChanged: (_) {}),
            onPressed: () => _activate(MenuEntry.logout),
            child: Text(
              'Logout',
              style: TextStyle(
                color: palette.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return TextButton(
            focusNode: _buttonFocusNode,
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: UserImage(
              user: state is LoadedState ? state.user : null,
            ),
          );
        },
      ),
    );
  }

  void _activate(MenuEntry selection) {
    if (selection == MenuEntry.logout) {
      BlocProvider.of<UserCubit>(context).logout();
    }
  }
}
