import 'package:bolsa_anjos/logins_pages/signin_email_password.dart';
import 'package:bolsa_anjos/widgets/widgets_constructor.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetsConstructor().makeSimpleText("Login", Colors.white, 18.0),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 100.0,),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text("Log In Using Email",
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
          )

        ],
      ),
    );
  }
}
