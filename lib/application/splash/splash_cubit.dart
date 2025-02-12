
import 'package:card/application/splash/splash_state.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  final UserRepository _userRepository;
  SplashCubit(this._userRepository) : super(Loading());

  void initialLoad() async {
    var user = await _userRepository.getCurrentUser();
    emit(Loaded(user));
  }

}