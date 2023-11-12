import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      return FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }
  }
}
