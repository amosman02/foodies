import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  signInWithGoogle(context) async {
    // Begin interactive signin with process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtian auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create new credintials for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Finally let's sign in
    final userCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid)
        .set({
      'email': userCredentials.user!.email,
      'name': userCredentials.user!.displayName,
    });
    Navigator.of(context).pop();
    return userCredentials;
  }

  // Signout user
  signOut() async {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}
