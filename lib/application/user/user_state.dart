part of 'user_cubit.dart';

abstract class UserState {

}

class LoadingState extends UserState { }
class LoadedState extends UserState {
  final User user;

  LoadedState(this.user);
}

class LogoutState extends UserState { }