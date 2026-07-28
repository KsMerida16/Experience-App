import 'package:experience_app/feature/ecommerce/data/data_source/local_logout_data_source.dart';
import 'package:experience_app/feature/ecommerce/data/repositories/logout_repository_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await initDashboardDependencies();
}

Future<void> initDashboardDependencies() async {
  getIt.registerSingleton<LocalLogoutDatasource>(LocalLogoutDatasource());
  getIt.registerLazySingleton<LogoutRepositoryImpl>(
    () => LogoutRepositoryImpl(
      localLogoutDatasource: getIt<LocalLogoutDatasource>(),
    ),
  );
}
