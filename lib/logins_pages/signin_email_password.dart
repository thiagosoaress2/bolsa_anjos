import 'package:bolsa_anjos/classes/user_class.dart';
import 'package:bolsa_anjos/logins_pages/auth_rotines.dart';
import 'package:bolsa_anjos/mobs/mob_auth.dart';
import 'package:bolsa_anjos/models/user_models.dart';
import 'package:bolsa_anjos/pages/home_page.dart';
import 'package:bolsa_anjos/pages/reg_user.dart';
import 'package:bolsa_anjos/widgets/widgets_constructor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class SignInWithEmailPassowrd extends StatefulWidget {
  @override
  _SignInWithEmailPassowrdState createState() => _SignInWithEmailPassowrdState();
}

class _SignInWithEmailPassowrdState extends State<SignInWithEmailPassowrd> {

  /*
  https://medium.com/firebase-tips-tricks/how-to-use-firebase-authentication-in-flutter-50e8b81cb29f
   */

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  //TextEditingController ageController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>(); //para snackbar

  MobAuth _mobAuth = MobAuth();

  String _page = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: WidgetsConstructor().makeSimpleText("Registro usuário", Colors.white, 18.0), backgroundColor: Colors.blue,),
      key: _scaffoldKey,
      body: _mobAuth.isLoading ? Center(child: CircularProgressIndicator(),) :
          _page == "login"
          ? signInUserScreen() : _page == "create"
          ? createUserScreen()
          : Container(),
    );
  }

  _displaySnackBar(BuildContext context, String msg) {

    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: "Ok",
        onPressed: (){
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }




  Widget signInUserScreen (){
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Informe o e-mail';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Informe a senha';
                      }
                      return null;
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: WidgetsConstructor().makeText("Novo usuário", Colors.blue, 18.0, 10.0, 30.0, "no"),
                      onTap: (){
                        setState(() {
                          _page = "create";
                        });
                      },
                    ),

                    GestureDetector(
                      child: WidgetsConstructor().makeText("Esqueceu a senha?", Colors.blue[300], 18.0, 10.0, 30.0, "no"),
                      onTap: (){
                        setState(() {
                          _page = "recover";
                        });
                      },
                    ),

                  ],
                ),

                SizedBox(height: 30.0,),
                Container(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {

                        signIn();

                      }
                    },
                    child: Text('Entrar'),
                  ),
                )

              ],
            ),
          ),
        ),
      ],
    );
  }

  void signIn() async {
    _mobAuth.setLoading(true);

    firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((user) async {
      AuthRotines().firebaseUser = user as FirebaseUser;
      //load user info
      _loadUserData();
      _mobAuth.setLoading(false);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );

    }
    );

  }

  Widget createUserScreen (){
    return ListView(
      children: [

        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nome completo (conforme documento)",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Informe o nome';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Informe o e-mail';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Informe a senha';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: passwordConfirmationController,
                    decoration: InputDecoration(
                      labelText: "Confirme a senha",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                    ),
                    //validator recebe o valor
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Confirme a senha';
                      }
                      return null;
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
        SizedBox(height: 30.0,),
        Container(
          child: RaisedButton(
            color: Colors.lightBlue,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (passwordController.text.length <=5){
                  _displaySnackBar(context, "A senha deve conter pelo menos seis dígitos");
                } else {
                  if (passwordController.text == passwordConfirmationController.text){
                    register();
                  } else {
                    _displaySnackBar(context, "As senhas informadas não são iguais");
                  }
                }

              }
            },
            child: Text('Registrar'),
          ),
        )
      ],
    );
  }

  void register() async {
    setState(() {
      _mobAuth.setLoading(true);
    });


    firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).whenComplete(() {

      AuthRotines().addNewUSerToBd(nameController.text, emailController.text).whenComplete(() {

        UserModels().newUserCreated(nameController.text, emailController.text);

        setState(() {
          _mobAuth.setLoading(false);
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage())
        );
      });

    }).catchError((error){
      String errorCode = error.toString();
      if (errorCode.contains("EMAIL_ALREADY_IN_USE")){
        _displaySnackBar(context, "Este e-mail já está cadastrado");
      } else {
        _displaySnackBar(context, "Um erro ocorreu");
      }

      setState(() {
        _mobAuth.setLoading(false);
      });
    });
  }

  Future<Null> _loadUserData() async {
    if (AuthRotines().firebaseUser == null){

        AuthRotines().firebaseUser = await AuthRotines().auth.currentUser();
        if(AuthRotines().firebaseUser != null){
          if(UserModels().user.name == null){
            DocumentSnapshot docUser = await Firestore.instance.collection("users").document(AuthRotines().firebaseUser.uid).get();
            UserModels().user.name = docUser["name"];
            UserModels().user.isLoggedIn = true;
            UserModels().user.email = docUser["email"];
            UserModels().user.hasIdeas = docUser["hasIdeas"];
            UserModels().user.hasInvestments = docUser["hasInvestments"];
          }
        }
    } else {
      if(UserModels().user.name == "no"){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(AuthRotines().firebaseUser.uid).get();
        UserModels().user.name = docUser["name"];
        UserModels().user.isLoggedIn = true;
        UserModels().user.email = docUser["email"];
        UserModels().user.hasIdeas = docUser["hasIdeas"];
        UserModels().user.hasInvestments = docUser["hasInvestments"];
      }
    }

  }
}


