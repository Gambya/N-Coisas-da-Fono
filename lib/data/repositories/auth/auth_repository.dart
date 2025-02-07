import 'package:ncoisasdafono/domain/entities/user.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AuthRepository {
  AsyncResult<LoggedUser> signInWithEmailAndPassword(
      String email, String password);
  AsyncResult<LoggedUser> signUpWithEmailAndPassword(
      String email, String password);
  AsyncResult<LoggedUser> signInWithGoogle();
  AsyncResult<Unit> signOut();
  AsyncResult<bool> isSignedIn();
  AsyncResult<User> getUser();
  Stream<User> userObserver();
  void dispose();
}
