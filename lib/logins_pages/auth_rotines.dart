import 'package:bolsa_anjos/mobs/mob_auth.dart';
import 'package:bolsa_anjos/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRotines {

  FirebaseUser firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addNewUSerToBd(String nome, String email) async {

    DocumentReference refFireStore = await Firestore.instance.collection('users').add({

      'name' : nome,
      'email' : email,
      'date_join' : DateTime.now().toString(),

    }).then((value) {

        final CollectionReference collectionReference = Firestore.instance.collection("users");
        collectionReference.document(value.documentID).updateData({'id' : value.documentID.toString()});
        /*
        collectionReference.document(value.documentID).updateData({'id' : value.documentID.toString()}).whenComplete(()
          async {

            //invocar user
           //_loadUserData();

          }
        ).catchError((e) => (){
            //erro ocorreu
          print(e.toString());

        });

         */

    });
  }


  Future<bool> isUserLoggedIn () async {

    firebaseUser = await AuthRotines().auth.currentUser();
    if (firebaseUser == null){
        //user not loggedIn
      return false;
    } else {
      _loadUserData();
      return true;
    }

  }

  Future<Null> _loadUserData() async {
    if (firebaseUser == null){

      firebaseUser = await auth.currentUser();
      if(firebaseUser != null){
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