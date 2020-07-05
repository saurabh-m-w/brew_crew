import 'package:brew_crew/modules/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey =GlobalKey<FormState>();
  final List<String> sugars =['0','1','2','3','4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;


  @override
  Widget build(BuildContext context) {

    final user =Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Update your brew Settings',style: TextStyle(fontSize: 18.0),),
                SizedBox(height: 20.0,),
                TextFormField(
                  initialValue: userData.name,
                  decoration: InputDecoration(

                    fillColor:  Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink[100],width: 2.0)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink,width: 2.0)),
                  ),
                  validator: (val)=>  val.isEmpty ? 'Please Enter Name':null,
                  onChanged: (val){setState(() {
                    _currentName=val;
                  });},
                ),
                SizedBox(height: 20.0,),
                //dropdown
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor:  Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink[100],width: 2.0)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink,width: 2.0)),
                    ),
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value:sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val){setState(() {
                      _currentSugars=val;
                    });}
                ),
                SizedBox(height: 30,),
                //slider
                Text('Coffee Strength'),
                Slider(
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(()=> _currentStrength=val.round()),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text('Update',style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    if(_formKey.currentState.validate())
                    {
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? snapshot.data.sugars,
                          _currentName ?? snapshot.data.name,
                          _currentStrength ?? snapshot.data.strength
                      );
                      Navigator.pop(context);
                    }

                  },
                )
              ],
            ),
          );
        }
        else{
            return Loading();
        }


      }
    );
  }
}
