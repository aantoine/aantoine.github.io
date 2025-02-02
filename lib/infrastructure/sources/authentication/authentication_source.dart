
import 'package:card/domain/user/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;

abstract class AuthenticationSource {
  Stream<User?> getUser();
}

class FirebaseAuthenticationSource extends AuthenticationSource {

  @override
  Stream<User?> getUser() {
    return f.FirebaseAuth.instance.authStateChanges().map((dataUser) {
      if (dataUser != null) {
        return User(dataUser.email ?? "", dataUser.displayName ?? "");
      }
      return null;
    });
  }
}