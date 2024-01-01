import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email already in use"),
          ),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password must be atleast 6 characters"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("unkown error ${e.code}"),
          ),
        );
      }
    }
    ;
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid email or passowrd"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${e.code}"),
          ),
        );
      }
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      UserCredential credential =
          await _auth.signInWithProvider(_googleAuthProvider);

      // Validate the user's email address against the organization's domain
      String userEmail = credential.user?.email ?? '';
      if (!_isValidOrganizationEmail(userEmail)) {
        // Show an error message or take appropriate action for invalid email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Invalid email address. Please use institute's email."),
          ),
        );
        // Sign out the user from Google authentication
        await _auth.signOut();
        return null;
      }

      return credential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return null;
    }
  }

  bool _isValidOrganizationEmail(String email) {
    String organizationDomain = 'iiitdwd.ac.in';
    return email.endsWith('@$organizationDomain');
  }
}
