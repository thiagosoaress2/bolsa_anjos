import 'package:bolsa_anjos/classes/user_class.dart';
import 'package:bolsa_anjos/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'mob_auth.g.dart';

class MobAuth = _MobAuth with _$MobAuth;

abstract class _MobAuth with Store {



  @observable
  bool isLoading = false;

  @observable
  String userMail= "no";

  @action
  void setLoading(bool state){
    isLoading = state;
  }

  @action
  String setEmail(String email){
    userMail = email;
  }



}
