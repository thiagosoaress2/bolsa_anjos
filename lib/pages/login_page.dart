import 'package:bolsa_anjos/logins_pages/signin_email_password.dart';
import 'package:bolsa_anjos/widgets/widgets_constructor.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>(); //para snackbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetsConstructor().makeSimpleText("Login", Colors.white, 18.0),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: ListView(
        children: [
          SizedBox(height: 100.0,),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text("Login com e-mail",
                    style: TextStyle(
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInWithEmailPassowrd()),
                );
              },
            ),
          ),
          SizedBox(height: 50.0,),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: GestureDetector(
              child: Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: FlatButton(
                  child: Text("Login com Facebook",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white)),
                  onPressed: (){
                    _displaySnackBar(context, "Esta função ainda não está disponível.");
                  },
                )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInWithEmailPassowrd()),
                );
              },
            ),
          ),

        ],
      ),
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
}
