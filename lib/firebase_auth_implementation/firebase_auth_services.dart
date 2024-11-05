import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInCtnSldCredentials(String ctnsldEmail, String ctnsldPassword) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: ctnsldEmail, password: ctnsldPassword);
      return credential.user;
    } catch (e) {
      print("An error has occured: $e");
    }
    return null;
  }
}