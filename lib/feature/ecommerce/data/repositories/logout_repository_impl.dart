import 'package:experience_app/core/utils/dependencies.dart';
import 'package:experience_app/feature/ecommerce/data/data_source/local_logout_data_source.dart';
import 'package:experience_app/feature/ecommerce/domain/repositories/logout_repository.dart';

class LogoutRepositoryImpl extends LogoutRepository {
  final LocalLogoutDatasource _localLogoutDatasource;

  LogoutRepositoryImpl({LocalLogoutDatasource? localLogoutDatasource})
    : _localLogoutDatasource =
          localLogoutDatasource ?? getIt<LocalLogoutDatasource>();

  @override
  Future<void> logOut() async {
    await _localLogoutDatasource.clearSession();
  }
}
