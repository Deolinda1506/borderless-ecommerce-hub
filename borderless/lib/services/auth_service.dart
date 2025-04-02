import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  late final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  AuthService() {
    if (kIsWeb) {
      _auth = FirebaseAuth.instanceFor(app: Firebase.app());
    } else {
      _auth = FirebaseAuth.instance;
    }
  }

  User? get currentUser => _auth.currentUser;

  String _generateOTP() {
    const String chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future<Map<String, dynamic>?> signUpWithEmail(
      String email, String password, String fullName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await createUser(user.uid, email, fullName);
        String otp = _generateOTP();

        await _firestore.collection('otps').doc(user.uid).set({
          'otp': otp,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt':
              DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
        });

        final callable = _functions.httpsCallable('sendOTP');
        await callable.call({'email': email, 'otp': otp});

        return {
          'user': user,
          'otp': otp, // For debugging; remove in production
        };
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'Sign-up failed. Please try again.';
      }
      print(e.toString());
      return {'error': errorMessage};
    }
  }

  Future<Map<String, dynamic>?> signInWithEmail(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': result.user};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'This email is not registered. Please sign up.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      print(e.toString());
      return {'error': errorMessage};
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        UserCredential result = await _auth.signInWithPopup(provider);
        User? user = result.user;
        if (user != null) {
          DocumentSnapshot doc =
              await _firestore.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await createUser(
                user.uid, user.email ?? '', user.displayName ?? '');
          }
          return {'user': user};
        }
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return {'error': 'Google Sign-In cancelled by user.'};
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;
        if (user != null) {
          DocumentSnapshot doc =
              await _firestore.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await createUser(
                user.uid, user.email ?? '', user.displayName ?? '');
          }
          return {'user': user};
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Account exists with a different sign-in method.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Google credentials.';
          break;
        default:
          errorMessage = 'Google Sign-In failed. Please try again.';
      }
      print(e.toString());
      return {'error': errorMessage};
    } catch (e) {
      print(e.toString());
      return {'error': 'An unexpected error occurred during Google Sign-In.'};
    }
  }

  Future<void> createUser(String uid, String email, String fullName) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'fullName': fullName,
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> verifyOTP(String userId, String inputOTP) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('otps').doc(userId).get();
      if (!doc.exists) {
        return {'error': 'OTP not found or expired.'};
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String storedOTP = data['otp'];
      int expiresAt = data['expiresAt'];

      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        await _firestore.collection('otps').doc(userId).delete();
        return {'error': 'OTP has expired.'};
      }

      if (inputOTP == storedOTP) {
        await _firestore.collection('otps').doc(userId).delete();
        return {'success': true};
      } else {
        return {'error': 'Invalid OTP.'};
      }
    } catch (e) {
      print(e.toString());
      return {'error': 'Failed to verify OTP.'};
    }
  }

  Future<Map<String, dynamic>?> resendOTP(String userId, String email) async {
    try {
      String otp = _generateOTP();
      await _firestore.collection('otps').doc(userId).set({
        'otp': otp,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt':
            DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
      });

      final callable = _functions.httpsCallable('sendOTP');
      await callable.call({'email': email, 'otp': otp});

      return {'otp': otp}; // For debugging; remove in production
    } catch (e) {
      print(e.toString());
      return {'error': 'Failed to resend OTP.'};
    }
  }
}
