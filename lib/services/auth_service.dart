import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'dart:async';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

 
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  User? get currentUser => _auth.currentUser;

 
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );

      User? user = result.user;
      
      if (user != null) {
        
        await user.sendEmailVerification();
        
       
        await user.updateDisplayName(displayName);
        
       
        AppUser appUser = AppUser(
          uid: user.uid,
          email: user.email!,
          displayName: displayName,
          emailVerified: false,
          createdAt: DateTime.now(),
        );

        await _db.child('users').child(user.uid).set(appUser.toMap());
        
        return appUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } on TimeoutException catch (e) {
      throw Exception('Connection timeout. Check your internet.');
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }


  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );

      User? user = result.user;
      
     
      if (user != null) {
        final snapshot = await _db.child('users').child(user.uid).get();
        
        if (!snapshot.exists) {
          AppUser appUser = AppUser(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName,
            emailVerified: user.emailVerified,
            createdAt: DateTime.now(),
          );
          await _db.child('users').child(user.uid).set(appUser.toMap());
        }
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } on TimeoutException catch (e) {
      throw Exception('Connection timeout. Check your internet.');
    }
  }

  
  Future<void> signOut() async {
    await _auth.signOut();
  }

 
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

 
  Future<void> sendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

 
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}