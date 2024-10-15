import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInCtnSldCredentials(String ctnsld_Email, String ctnsld_Password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: ctnsld_Email, password: ctnsld_Password);
      return credential.user;
    } catch (e) {
      print("An error has occured.");
    }
  }
}