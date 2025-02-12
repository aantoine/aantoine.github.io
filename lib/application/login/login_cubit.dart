
import 'package:card/domain/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;
  LoginCubit(this._userRepository) : super(InitialState());

  void login() async {
    try {
      await _userRepository.login();
      emit(LoadedState());
    } on Exception catch (e) {
      print(e);
      emit(ErrorState());
    }
  }

}