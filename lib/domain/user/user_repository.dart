import 'package:card/domain/user/entities/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User> login();
  Future<void> logout();
}