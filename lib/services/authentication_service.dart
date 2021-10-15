import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _databaseServices = DatabaseServices();

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully LoggedIn";
    } on FirebaseAuthException catch (e) {
      print("MyFirebaseAuthException Login: $e");
      return e.message;
    }
  }

  Future<String?> signUp(String name, String email, password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user.user != null) {
        final r = await _databaseServices.saveUser(UserModel(
            id: user.user!.uid, name: name, email: email, imageUrl: ""));
        print(r);
      }
      return "Successfully SignedUp";
    } on FirebaseAuthException catch (e) {
      print("MyFirebaseAuthException SignUp: $e");
      return e.message;
    }
  }

  Future<String> resetPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return "Email Sent Successfully";
    }on FirebaseAuthException catch(e){
      print("MyFirebaseAuthException ResetPassword: ${e.message}");
      return e.message!;
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return "Successfully SignedOut";
    } on FirebaseAuthException catch (e) {
      print("MyFirebaseAuthException SignOut: $e");
    }
  }
}
