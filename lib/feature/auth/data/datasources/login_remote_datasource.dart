import 'package:experience_app/feature/auth/data/models/user_model.dart';
import 'package:experience_app/feature/auth/data/models/user_password_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseLoginDatasource {
  final FirebaseAuth _auth;
  FirebaseLoginDatasource({required FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  Future<UserModel> register({
    required UserPasswordModel userPasswordModel,
  }) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: userPasswordModel.email,
      password: userPasswordModel.password,
    );
    return UserModel(
      email: credentials.user!.email!,
      id: credentials.user!.uid,
      username: '',
      firstName: '',
      lastName: '',
      gender: '',
      image: '',
      accessToken: '',
      newId: '',
    );
  }

  Future<UserModel> login({
    required UserPasswordModel userPasswordModel,
  }) async {
    final credentials = await _auth.signInWithEmailAndPassword(
      email: userPasswordModel.email,
      password: userPasswordModel.password,
    );

    return UserModel(
      email: credentials.user!.email!,
      id: credentials.user!.uid,
      username: '',
      firstName: '',
      lastName: '',
      gender: '',
      image: '',
      accessToken: '',
      newId: '',
    );
  }

  Future<bool> isLogged() {
    return _auth.currentUser != null ? Future.value(true) : Future.value(false);
  }

  Future<bool> logout() {
    return _auth.signOut().then((value) => true);
  }
}