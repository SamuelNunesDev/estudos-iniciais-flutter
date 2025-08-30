import 'package:chat_online/notifier_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService extends ChangeNotifier {
  FirebaseService._() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
    _login(delay: 2);
  }

  static final FirebaseService instance = FirebaseService._();

  get user => _currentUser;

  User? _currentUser;

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn.instance.signOut();
    _currentUser = null;
    notifyListeners();
    NotifierHelper.show('Logout efetuado com sucesso.', color: Colors.green);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
  getStreamSnapshotsMessagesOrdered() {
    return FirebaseFirestore.instance
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  void _login({int? delay}) async {
    if (delay != null) {
      await Future.delayed(Duration(seconds: delay));
    }
    if (_currentUser != null) {
      return;
    }
    _currentUser = await getUser(login: true);
    notifyListeners();
  }

  Future<User?> getUser({bool? login}) async {
    try {
      if (_currentUser != null) {
        return _currentUser;
      }
      if (login == false) {
        return null;
      }
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '703106098084-fgg3kfbtdfgnb2mnmd00vnbbbco9ags2.apps.googleusercontent.com',
      );
      final GoogleSignInAccount googleSignInAccount = await GoogleSignIn
          .instance
          .authenticate();
      final GoogleSignInAuthentication googleSignInAuthentication =
          googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(credential);
      return authResult.user;
    } catch (error) {
      return null;
    }
  }

  void sendMessage(data) {
    FirebaseFirestore.instance.collection('messages').add(data);
  }
}
