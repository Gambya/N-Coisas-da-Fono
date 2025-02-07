import 'dart:async';

import 'package:ncoisasdafono/data/repositories/auth/auth_repository.dart';
import 'package:ncoisasdafono/domain/entities/user.dart';
import 'package:result_dart/src/types.dart';
import 'package:result_dart/src/unit.dart';

class RemoteAuthRepository implements AuthRepository {
  final _streamController = StreamController<User>.broadcast();

  @override
  AsyncResult<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  AsyncResult<bool> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  AsyncResult<LoggedUser> signInWithEmailAndPassword(
      String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  AsyncResult<LoggedUser> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
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
