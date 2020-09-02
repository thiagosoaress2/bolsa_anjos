import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'mob_auth.g.dart';

class MobAuth = _MobAuth with _$MobAuth;

abstract class _MobAuth with Store {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  @observable
  bool isLoading = false;

  @action
  void setLoading(bool state){
    isLoading = state;
  }

  void signIn(@required String email, String pass, @required VoidCallback onSuccess, @required VoidCallback onFailure) async {
    setLoading(true);

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async {
      firebaseUser = user as FirebaseUser;

      //await _loadCurrentUserData();

      onSuccess();
      isLoading = false;
    }).catchError((error){
      onFailure();
      isLoading = false;
    });

  }



}
