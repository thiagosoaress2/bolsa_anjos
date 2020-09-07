import 'package:bolsa_anjos/mobs/mob_auth.dart';
import 'package:bolsa_anjos/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRotines {

  FirebaseAuth _auth;// = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  //Map<String, dynamic> userData = Map();

  void initAuthRotines(){
    _auth = FirebaseAuth.instance;
  }

  //cadastro
  Future<void> signUp(@required Map<String, dynamic> userData, @required String password, @required VoidCallback onSuccess, @required VoidCallback onFailure) async {
    //isLoading = true;
    //notifyListeners();
    MobAuth().setLoading(true);

    _auth.createUserWithEmailAndPassword(email: userData["email"], password: password).whenComplete(() async {

      //firebaseUser = this.firebaseUser;
      firebaseUser = await _auth.currentUser();

      await _saveUserData(userData);

      onSuccess();
      //isLoading = false;
      //notifyListeners();
      MobAuth().setLoading(false);

    }).catchError((error){
      print(error.toString());
      onFailure();
      //isLoading = false;
      //notifyListeners();
      MobAuth().setLoading(false);
    });

  }

  //login
  void signIn(@required String email, String pass, @required VoidCallback onSuccess, @required VoidCallback onFailure) async {
    MobAuth().setLoading(true);

    _auth.signInWithEmailAndPassword(email: email, password: pass).whenComplete(() async {

      firebaseUser = await _auth.currentUser();
      await loadCurrentUserData();
      onSuccess();
      MobAuth().setLoading(false);

    }
    ).catchError((error){
      onFailure();
      MobAuth().setLoading(false);
    });

  }

  //salvar os dados iniciais do user no bd
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    //this.userData = userData;
    UserModel().userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  //lê as informações do usuário do bd
  Future<Null> loadCurrentUserData() async {
    if(firebaseUser == null){  //verifica se tem acesso a informação do user
      firebaseUser = await _auth.currentUser(); //se for nulo, vai tentaar pegar
      if (firebaseUser != null){ //verifica novamente
        if(UserModel().userData["name"] == null){
          DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
          UserModel().userData = docUser.data;
          UserModel().upDateUserEmail(docUser['email']);

          MobAuth().setEmail(UserModel().userData['email']);
        }
      }
    } else {
      if(UserModel().userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        UserModel().userData = docUser.data;
        MobAuth().setEmail(UserModel().userData['email']);
        UserModel().upDateUserEmail(UserModel().userData['email']);
      }
    }

  }

  //envia e-mail de recuperação de senha
  void recoverPass(@required String email){
    _auth.sendPasswordResetEmail(email: email);
  }

   isLoggedIn() async {

    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null){
      loadCurrentUserData();
    }
    //return firebaseUser != null ; //retorna true se firebaseuser for diferente de null
  }

  void signOut() async{

    await _auth.signOut();

    UserModel().userData = Map();
    firebaseUser = null;

  }

  String getName(){
    return UserModel().userData['name'];
  }

  /*
  String getEmail(){
    return userMail;
  }

   */

  String get getEmail => UserModel().userData['email'];

}