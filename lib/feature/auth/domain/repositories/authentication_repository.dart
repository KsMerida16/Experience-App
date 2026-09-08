import 'package:experience_app/feature/auth/domain/entities/user_model.dart';

abstract class AuthenticationRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String> getUserEmail();
  Future<bool> logOut();
  Future<bool> registerWithEmailAndPassword(String email, String password);
  Future<String> getAccessToken();
  Future<User> signIUpWithEmailAndPassword(String email, String password);
  Future<void> saveSession(String token);
}
