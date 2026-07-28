import 'package:experience_app/feature/auth/data/datasources/firebase_remote_authentication_data_source.dart';
import 'package:experience_app/feature/auth/domain/entities/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

class AuthNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final dataSource = ref.read(authDataSourceProvider);
    return dataSource.getCurrentUser();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final dataSource = ref.read(authDataSourceProvider);
    state = await AsyncValue.guard(
      () => dataSource.signIn(email: email, password: password),
    );
  }

  Future<void> signUp(String email, String password, {String? name}) async {
    state = const AsyncLoading();
    final dataSource = ref.read(authDataSourceProvider);
    state = await AsyncValue.guard(
      () => dataSource.signUp(email: email, password: password, name: name),
    );
  }

  Future<void> signOut() async {
    final dataSource = ref.read(authDataSourceProvider);
    await dataSource.signOut();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  AuthNotifier.new,
);
