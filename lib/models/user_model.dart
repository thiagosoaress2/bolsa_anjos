import 'package:bolsa_anjos/classes/user_class.dart';

class UserModel {

  UserClass user =  UserClass("no", "no", false, false);

  Map<String, dynamic> userData = Map();


  void upDateUserName(String name){
    user.name = name;
  }

  void upDateUserEmail(String email){
    user.email = email;
  }




}