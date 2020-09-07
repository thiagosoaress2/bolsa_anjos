import 'package:bolsa_anjos/classes/user_class.dart';
import 'package:bolsa_anjos/logins_pages/auth_rotines.dart';
import 'package:bolsa_anjos/mobs/mob_auth.dart';
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
                          //_page = "recover";
                          if(emailController.text.isNotEmpty){
                            if(emailController.text.contains("@") && emailController.text.contains(".")){
                              AuthRotines().recoverPass(emailController.text);
                              //AuthRotines().recoverPass(emailController.text);
                              _displaySnackBar(context, "Enviamos um e-mail. Verifique e siga as instruções para recuperar a senha.");

                            } else {
                              _displaySnackBar(context, "Ops, tem algo errado no e-mail informado.");
                            }

                          } else {
                            _displaySnackBar(context, "Informe um e-mail para reenviarmos sua senha.");
                          }

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

                        //signIn();
                        AuthRotines().signIn(emailController.text, passwordController.text, () {_onSucess(); }, () {_onFailure(); });

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
                    //register(() {_onSucess();}, () {_onFailure();});

                    Map<String, dynamic> userData = {
                      "name" : nameController.text,
                      "email" : emailController.text,
                    };
                    AuthRotines().signUp(userData, passwordController.text, () {_onSucess();}, () {_onFailure();});

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

  void _onSucess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(_page=="create" ? "Usuário criado com sucesso!" : "Você está logado."), backgroundColor: Theme.of(context).primaryColor, duration: Duration(seconds: 3),)
    );
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pop();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );

    });

  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(_page=="login" ? "Ocorreu um erro na identificação." : "O usuário não foi criado. Um erro ocorreu."), backgroundColor: Colors.red, duration: Duration(seconds: 5),)
    );

  }

  /*
  void signIn() async {
    _mobAuth.setLoading(true);

    firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((user) async {
      AuthRotines().firebaseUser = user as FirebaseUser;
      //load user info
      //_loadUserData();
      _mobAuth.setLoading(false);
      AuthRotines().isUserLoggedIn(); //aqui carrega os dados

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );

    }
    );

  }

  void register(@required VoidCallback onSuccess, @required VoidCallback onFailure) async {
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

  void _onSucess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso!"), backgroundColor: Theme.of(context).primaryColor, duration: Duration(seconds: 3),)
    );
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pop();

    });
  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("O usuário não foi criado. Um erro ocorreu"), backgroundColor: Colors.red, duration: Duration(seconds: 5),)
    );

  }

   */
}


