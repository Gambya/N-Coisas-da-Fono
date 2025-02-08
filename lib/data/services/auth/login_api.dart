import 'package:google_sign_in/google_sign_in.dart';

class LoginAPI {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<void> logout() => _googleSignIn.signOut();
}
