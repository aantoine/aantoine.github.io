import 'package:card/domain/user/entities/user.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';

class UserRepositoryImplementation extends UserRepository {

  final AuthenticationSource _authenticationSource;

  UserRepositoryImplementation(this._authenticationSource);

  @override
  Future<User?> getCurrentUser() {
    return _authenticationSource.getUser().first;
  }

  @override
  Future<User> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

}