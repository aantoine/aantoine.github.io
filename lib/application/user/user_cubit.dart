import 'package:card/domain/user/entities/user.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  UserCubit(this._userRepository) : super(LoadingState()) {
    _userRepository.getCurrentUser().then((user) {
      if (user != null) {
        emit(LoadedState(user));
      }
    });
  }
}