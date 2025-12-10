import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_app/models/authmodel.dart';

class Authstate extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isloading = false;

  bool get isLoading => _isloading;
  String _name = '';
  String _email = '';
  String get name => _name;
  String get email => _email;

  AuthModel? _usermodel;
  AuthModel? get usermodel => _usermodel;

  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  //  Signup
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isloading = true;
      notifyListeners();

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      AuthModel usermodel = AuthModel(
        id: uid,
        name: name,
        email: email,
        timestamp: DateTime.now(),
      );

      await _firestore.collection("users").doc(uid).set(usermodel.toJson());

      _usermodel = usermodel;
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  Future<void> Login({required String Email, required String Password}) async {
    _isloading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: Email,
        password: Password,
      );
      final userId = userCredential.user!.uid;
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        print(doc.data());
        print("Login Successfull");
      } else {
        print("Login Unsuccessfull");
        throw Exception("Login Unsuccessfull");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({required String email}) async {
    _isloading = true;
    notifyListeners();

    try {
      await auth.sendPasswordResetEmail(email: email);
      print(' Password reset email sent');
    } on FirebaseAuthException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.message);
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
