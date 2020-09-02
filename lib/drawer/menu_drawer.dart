import 'package:bolsa_anjos/models/user_models.dart';
import 'package:bolsa_anjos/pages/login_page.dart';
import 'package:bolsa_anjos/pages/reg_user.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding:EdgeInsets.only(top: 16.0),
        children: [
          DrawerHeader(  //cabeçalho
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(UserModels().user == null || UserModels().user.email == "no" ? "Você ainda não se identificou" : UserModels().user.email, style: TextStyle(color: Colors.white)),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          InkWell( //toque com animação
            onTap: (){ //click
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LoginPage()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.0),
              child: _drawLine(Icons.person, "Login", Theme.of(context).primaryColor, context),
            ),
          ),
          InkWell( //toque com animação
            onTap: (){ //click
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RegUser()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.0),
              child: _drawLine(Icons.lightbulb_outline, "Registrar uma idéia", Theme.of(context).primaryColor, context),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _drawLine(IconData icon, String text, Color color, BuildContext context){

  return Material(
    color: Colors.transparent,
    child: Column(
      children: <Widget>[
        Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon, size: 32.0,
                color : Theme.of(context).primaryColor,
              ),
              SizedBox(width: 32.0,),
              Text(
                text, style: TextStyle(fontSize: 16.0,
                color : Theme.of(context).primaryColor,

              ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    ),
  );

}

