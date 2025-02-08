import 'dart:async';

import 'package:ncoisasdafono/data/repositories/auth/auth_repository.dart';
import 'package:ncoisasdafono/data/services/auth/login_api.dart';
import 'package:ncoisasdafono/domain/entities/user.dart';
import 'package:result_dart/result_dart.dart';

class RemoteAuthRepository implements AuthRepository {
  final _streamController = StreamController<User>.broadcast();

  @override
  AsyncResult<User> getUser() async {
    if (!await _streamController.stream.isEmpty) {
      return Success(await _streamController.stream.first);
    }
    return Success(User.empty());
  }

  @override
  AsyncResult<bool> isSignedIn() async {
    if (!await _streamController.stream.isEmpty) {
      return Success(true);
    }
    return Success(false);
  }

  @override
  AsyncResult<LoggedUser> signInWithEmailAndPassword(
      String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  AsyncResult<LoggedUser> signInWithGoogle() async {
    final user = await LoginAPI.login();
    final loggedUser = LoggedUser(
      id: user!.id,
      email: user.email,
      name: user.displayName!,
      photoUrl: user.photoUrl!,
      token: '',
      refreshToken: '',
    );
    _streamController.add(loggedUser);

    return Success(loggedUser);
  }

  @override
  AsyncResult<Unit> signOut() async {
    await LoginAPI.logout();
    _streamController.add(User.empty());
    return Success(unit);
  }

  @override
  AsyncResult<LoggedUser> signUpWithEmailAndPassword(
      String email, String password) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Stream<User> userObserver() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
