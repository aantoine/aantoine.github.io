part of 'login_cubit.dart';

abstract class LoginState {

}

class InitialState extends LoginState { }
class LoadedState extends LoginState { }
class ErrorState extends LoginState { }
class UnauthorizedState extends LoginState { }