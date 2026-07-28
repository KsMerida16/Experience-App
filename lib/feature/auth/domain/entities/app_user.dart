import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
sealed class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String uid,
    required String email,
    required String role,
  }) = _AppUser;

  bool get isAdmin => role == 'administrador';
}
