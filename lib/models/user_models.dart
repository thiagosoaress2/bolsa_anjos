import 'package:bolsa_anjos/classes/user_class.dart';

class UserModels {

  Map<String, dynamic> userData = Map();

  UserClass user = UserClass("no", false, "no", false, false);
  //toda informação do user ficará armazenada aqui
  Future<UserClass> loadUserClass () {
    user = UserClass("no", false, "no", false, false);
  }

  Future newUserCreated (String name, String email){
    user = UserClass("no", false, "no", false, false);
    user.name = name;
    user.email = email;
  }


}