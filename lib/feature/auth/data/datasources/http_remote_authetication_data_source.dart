import 'package:dio/dio.dart';
import 'package:experience_app/core/api_consts.dart';
import 'package:experience_app/feature/auth/data/datasources/remote_authentication_data_source.dart';
import 'package:experience_app/feature/auth/data/models/user_model.dart';
import 'package:experience_app/feature/auth/data/models/user_password_model.dart';

class HttpRemoteAutheticationDataSource extends RemoteAuthenticationDataSource {
  final dio = Dio();

  @override
  Future<UserModel> loginWithEmailPassword({
    required UserPasswordModel userPasswordModel,
  }) async {
    final response = await dio.post(
      ApiConsts.login,
      data: userPasswordModel.toJson(),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(
        'Error al registrar el usuario. Código de estado: ${response.statusCode}',
      );
    }
  }
}
