import 'package:brew_crew/home/setting_form.dart';
import 'package:brew_crew/modules/brew.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/home/brew_list.dart';

class Home extends StatelessWidget {

  final  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanal(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold (
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('BrewCrew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(onPressed:  () async{await _auth.signOut();}, icon: Icon(Icons.person), label: Text('Logout')),
            FlatButton.icon(onPressed: ()=>_showSettingsPanal(), icon: Icon(Icons.settings), label: Text('Settings'))
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
