import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/model/user_model.dart';

part 'current_user_notifier.g.dart';

// This provider is used to keep track the current user through out the app, that is why we put it in core/provider.
@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }
}
