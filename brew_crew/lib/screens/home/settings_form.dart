import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/database.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //pakai StreamBuilder, kalo di main.dart pakainya StreamProvider<User>
    //alasan pakai StreamBuilder karena StreamBuilder<UserData> ini hanya digunakan di widget ini saja, jadi ngga pakai provider.of
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData, //userData disini merupakan nama Streamnya,
      builder: (context, snapshot) {
        if(snapshot.hasData){ //jika kita mempunya data pada snapshot maka true dan program jalan

          UserData userData = snapshot.data; //membuat objek userData dari class userData, objek tersebut menyimpan data dari snapshot

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _currentSugars ?? userData.sugars, //value awal dari dropdownformfield
                  decoration: textInputDecoration,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar, //value yang dipilih
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars = val),
                ),
                Slider(
                  value: (_currentStrength ?? userData.strength).toDouble(), //karena value dari slider itu double
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                  min: 100,
                  max: 900,
                  divisions: 8, //banyaknya perpindahan
                  onChanged: (val) => setState(() => _currentStrength = val.round()), //membulatkan double val ke integer
                ),
                SizedBox(height: 10.0,),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      // ingat disini karena method updateUserData di dalamnya mengubah data yang ada di brewCollection, 
                      // dimana data brew tersebut diStreamProvider pada home.dart maka di widget lain yang provide.of<List<ListBrew>> akan terupdate juga.
                      await DatabaseService(uid: user.uid).updateUserData(  
                        _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength
                      );
                      Navigator.pop(context);
                    }
                  }
                )
              ],
            )
          );
        }else{
          return Loading(); //kalo ngga ada data di snapshot maka cuma nampilin loading screen wkwk
        }
        
      }
    );
  }
}