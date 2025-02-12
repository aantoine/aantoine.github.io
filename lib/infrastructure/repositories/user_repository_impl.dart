import 'package:card/domain/user/entities/user.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';

class UserRepositoryImplementation extends UserRepository {

  final AuthenticationSource _authenticationSource;
  User? currentUser;
  bool loaded = false;

  UserRepositoryImplementation(this._authenticationSource);

  @override
  Future<User?> getCurrentUser() async {
    if (loaded) {
      return currentUser;
    }
    currentUser = await _authenticationSource.getUser();
    loaded = true;
    return currentUser;
  }

  @override
  Future<User> login() async {
    var user = await _authenticationSource.login();
    currentUser = user;
    loaded = true;
    return user;
  }

}