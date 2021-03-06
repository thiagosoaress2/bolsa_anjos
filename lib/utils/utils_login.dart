import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UtilsLogin {

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signIn(@required String email, String pass, @required VoidCallback onSuccess, @required VoidCallback onFailure) async {
    isLoading = true;

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async {
      firebaseUser = user as FirebaseUser;

      await _loadCurrentUserData();

      onSuccess();
      isLoading = false;
    }).catchError((error){
      onFailure();
      isLoading = false;
    });

  }

  void signUp(@required Map<String, dynamic> userData, @required String password, @required VoidCallback onSuccess, @required VoidCallback onFailure){
    isLoading = true;

    _auth.createUserWithEmailAndPassword(email: userData["email"], password: password).then((user) async {
      firebaseUser = user as FirebaseUser;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
    }).catchError((error){
      onFailure();
      isLoading = false;
    });

  }

  void signOut() async{
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;
  }

  void recoverPass(@required String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){

    return firebaseUser != null ; //retorna true se firebaseuser for diferente de null
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUserData() async {
    if(firebaseUser == null){  //verifica se tem acesso a informação do user
      firebaseUser = await _auth.currentUser(); //se for nulo, vai tentaar pegar
      if (firebaseUser != null){ //verifica novamente
        if(userData["name"] == null){
          DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
          userData = docUser.data;
        }
      }
    } else {
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }

  }
}
