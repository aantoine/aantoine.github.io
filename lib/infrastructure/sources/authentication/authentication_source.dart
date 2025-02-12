import 'package:card/domain/user/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_core/firebase_core.dart';

abstract class AuthenticationSource {
  Future<User?> getUser();
  Future<User> login();
  Future<void> logout();
}

class FirebaseAuthenticationSource extends AuthenticationSource {

  late f.FirebaseAuth auth;

  FirebaseAuthenticationSource() {
    auth = f.FirebaseAuth.instanceFor(app: Firebase.app());
    auth.setPersistence(f.Persistence.LOCAL);
    auth.authStateChanges().listen((user) {
      if (user != null) {
        print("FirebaseAuthenticationSource: listen not null");
      } else {
        print("FirebaseAuthenticationSource: listen null");
      }
    });
  }

  @override
  Future<User?> getUser() async {
    var firebaseUser = auth.currentUser;
    firebaseUser ??= await auth.authStateChanges().first;

    if (firebaseUser != null) {
      print("FirebaseAuthenticationSource: user != null");
      return User(firebaseUser.email ?? "", firebaseUser.displayName ?? "", firebaseUser.uid);
    }
    print("FirebaseAuthenticationSource: user is null");
    return null;
  }

  @override
  Future<User> login() async {
    var credentials = await _signInWithGoogle();
    return User(
      credentials.user!.email!,
      credentials.user!.displayName!,
      credentials.user!.uid
    );
  }

  Future<f.UserCredential> _signInWithGoogle() async {
    f.GoogleAuthProvider googleProvider = f.GoogleAuthProvider();

    googleProvider.setCustomParameters({
      'login_hint': 'user@transapp.cl'
    });

    return await auth.signInWithPopup(googleProvider);
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }
}