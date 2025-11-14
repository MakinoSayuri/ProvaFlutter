import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signUp({required String email, required String password}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'createdAt': FieldValue.serverTimestamp(),
        'email': email,
      });

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  CollectionReference<Map<String, dynamic>> veiculosRef() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('veiculos');
  }


  CollectionReference<Map<String, dynamic>> abastecimentosRef() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('abastecimentos');
  }
}
