import 'package:experience_app/feature/auth/data/models/user_model.dart';
import 'package:experience_app/feature/auth/data/models/user_password_model.dart';

abstract class RemoteAuthenticationDataSource {
  Future<UserModel>  loginWithEmailPassword({required  UserPasswordModel userPasswordModel, });
}