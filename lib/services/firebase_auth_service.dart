import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future signup(String name, String email, String password, String bio, int age, int goalWeight, String imageUrl) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user's name and email in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'bio': bio,
        'age': age,
        'desired_weight': goalWeight,
        'profile_photo_url': imageUrl,
        'total_score': 0,
        // Add other user data if needed
      });
       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('bmiData').doc().set({
        // Example initial data if needed
      });
      // Create a blank subcollection called "exerciseData"
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).collection('exerciseData').doc().set({
        // Example initial data if needed
      });
    } catch (e) {
      debugPrint("Error creating user: $e");
      throw FirebaseAuthException(message: e.toString(), code: 'signup_failed');
    }
  }
  Future logininwithgoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential myCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential user =
    await FirebaseAuth.instance.signInWithCredential(myCredential);

    debugPrint(user.user?.displayName);
  }
}