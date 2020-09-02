import 'package:bolsa_anjos/classes/user_class.dart';
import 'package:bolsa_anjos/drawer/menu_drawer.dart';
import 'package:bolsa_anjos/logins_pages/auth_rotines.dart';
import 'package:bolsa_anjos/models/user_models.dart';
import 'package:bolsa_anjos/pages/reg_user.dart';
import 'package:bolsa_anjos/widgets/widgets_constructor.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    UserModels().loadUserClass();
    AuthRotines().isUserLoggedIn();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue, child: Icon(Icons.add_circle, size: 50.0,), onPressed: goToRegEntrepeneurPage,),
      appBar: AppBar(title: WidgetsConstructor().makeSimpleText("Oportunidades", Colors.white, 15.0),
                    backgroundColor: Colors.blue,
                    centerTitle: true,
      ),
      drawer: MenuDrawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200.0,
              color: Colors.blue,
              child: WidgetsConstructor().makeSimpleText("Oportunidade 1", Colors.white, 18.0),
            ),
            Container(
              height: 200.0,
              color: Colors.green,
              child: WidgetsConstructor().makeSimpleText("Oportunidade 2", Colors.white, 18.0),
            )
          ],
        ),
      ),
    );
  }

  goToRegEntrepeneurPage(){
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegUser()));
  }

}
