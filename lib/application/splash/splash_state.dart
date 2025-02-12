
import 'package:card/domain/user/entities/user.dart';

abstract class SplashState {}

class Loading extends SplashState {}
class Loaded extends SplashState {
  final User? currentUser;

  Loaded(this.currentUser);
}