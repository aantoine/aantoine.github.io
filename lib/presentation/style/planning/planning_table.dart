
import 'package:card/application/planning_table/models/user_with_vote_view_model.dart';
import 'package:card/application/planning_table/planning_table_cubit.dart';
import 'package:card/presentation/style/bloc_planning_session_builder.dart';
import 'package:card/presentation/style/palette.dart';
import 'package:card/presentation/style/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanningTable extends StatelessWidget {
  const PlanningTable({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return PlanningBlocBuilderProvider<PlanningTableCubit, PlanningTableState>(
      builder: (context, state) {
        String tableText;
        if (state.isHost) {
          if (state.revealing) {
            tableText = "Next Round";
          } else if (state.readyToReveal) {
            tableText = "Reveal votes";
          } else {
            tableText = "Waiting for votes";
          }
        } else {
          if (state.revealing) {
            tableText = "Revealing";
          } else {
            tableText = "Waiting for host";
          }
        }

        final onTap = state.isHost && (state.readyToReveal || state.revealing)
            ? () {
          if (state.revealing) {
            BlocProvider.of<PlanningTableCubit>(context).nextPlanning();
          } else {
            BlocProvider.of<PlanningTableCubit>(context).revealTable();
          }
        }
            : null;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // top users
              UserVotesWidget(
                userList: state.topList,
                imageAtTop: true,
                revealing: state.revealing,
              ),
              // Table
              Card(
                color: palette.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: state.isHost && (state.readyToReveal || state.revealing)
                      ? BorderSide(color: palette.primary)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: onTap,
                  splashColor: palette.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 72,
                    width: 144,
                    alignment: Alignment.center,
                    child: Text(
                      tableText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: palette.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              // bottom users
              UserVotesWidget(
                userList: state.bottomList,
                imageAtTop: false,
                revealing: state.revealing,
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserVotesWidget extends StatelessWidget {
  final List<UserWithVoteViewModel> userList;
  final bool imageAtTop;
  final bool revealing;
  const UserVotesWidget({
    super.key,
    required this.userList,
    required this.imageAtTop,
    required this.revealing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return SizedBox(
      height: 112,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: userList.length,
        itemBuilder: (context, index) {
          var userData = userList[index];
          var userImage = UserImage(user: userData.user);
          var card = Card(
            color: userData.vote != null
                ? palette.primaryContainer
                : palette.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: userData.vote == null
                  ? BorderSide(color: palette.surfaceOutline)
                  : BorderSide(color: palette.primary),
            ),
            child: Container(
              height: 54,
              width: 36,
              alignment: Alignment.center,
              child: userData.vote == null
                  ? Container()
                  : Text(
                revealing ? userData.vote ?? "?" : "OK",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageAtTop ? userImage : card,
                SizedBox(height: 8),
                imageAtTop ? card : userImage,
              ],
            ),
          );
        },
      ),
    );
  }
}