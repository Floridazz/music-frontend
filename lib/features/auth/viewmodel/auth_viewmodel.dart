import 'package:client_side/core/providers/current_user_notifier.dart';
import 'package:client_side/features/auth/model/user_model.dart';
import 'package:client_side/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/auth_local_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel?> build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return const AsyncValue.data(null);
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        _loginSuccess(r);
        // ADD THIS LINE:
        // Reset the state to idle (not loading) after success.
        state = const AsyncValue.data(null);
    }
  }

  void _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
  }

  // Need to understand more
  Future<void> getData() async {
    final token = _authLocalRepository.getToken();

    if (token == null) {
      return;
    }

    final res = await _authRemoteRepository.getCurrentUserData(token);
    final val = switch (res) {
      Left(value: final l) => null,
      Right(value: final r) => _currentUserNotifier.addUser(r),
    };
  }
}
