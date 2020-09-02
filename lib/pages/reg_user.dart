import 'package:bolsa_anjos/widgets/widgets_constructor.dart';
import 'package:flutter/material.dart';

class RegUser extends StatefulWidget {
  @override
  _RegUserState createState() => _RegUserState();
}

class _RegUserState extends State<RegUser> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: WidgetsConstructor().makeSimpleText("Registrar uma idéia", Colors.white, 18.0),centerTitle: true,),
      body: ListView(
        children: [
          Container(color: Colors.red, height: 100.0,)
        ],
      ),
    );
  }
}
