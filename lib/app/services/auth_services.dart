import 'package:conversai/app/constants/firebase_constants.dart';
import 'package:conversai/config/models/response_model.dart';
import 'package:conversai/config/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up User
  Future<ResponseModel> signUpUser({
    required String fullName,
    required String email,
    required String phoneNo,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserModel newUser = UserModel(
          fullName: fullName,
          email: email,
          phoneNo: phoneNo,
        );

        await _firestore
            .collection(AppFirebaseConstants.userCollectionName)
            .doc(user.uid)
            .set(newUser.toJson());
      }

      return ResponseModel(
        status: true,
        message: AppFirebaseConstants.signUpSuccessMessage,
        data: userCredential.user?.uid,
      );
    } on FirebaseAuthException catch (e) {
      return ResponseModel(
        status: false,
        message: e.message ?? AppFirebaseConstants.unexpectedErrorMessage,
        data: null,
      );
    }
  }

  // Sign In User
  Future<ResponseModel> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return ResponseModel(
        status: true,
        message: "Login successful!",
        data: userCredential.user?.uid,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          e.code == "wrong-password" || e.code == "user-not-found"
              ? AppFirebaseConstants.invalidCredentialMessage
              : e.message ?? AppFirebaseConstants.unexpectedErrorMessage;

      return ResponseModel(
        status: false,
        message: errorMessage,
        data: null,
      );
    }
  }

  // Forgot Password
  Future<ResponseModel> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ResponseModel(
        status: true,
        message: "Password reset email sent. Check your inbox!",
      );
    } on FirebaseAuthException catch (e) {
      return ResponseModel(
        status: false,
        message: e.message ?? AppFirebaseConstants.unexpectedErrorMessage,
      );
    }
  }

  // Sign Out User
  Future<ResponseModel> signOutUser() async {
    try {
      await _auth.signOut();
      return ResponseModel(
        status: true,
        message: "User signed out successfully!",
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: AppFirebaseConstants.unexpectedErrorMessage,
      );
    }
  }
}
