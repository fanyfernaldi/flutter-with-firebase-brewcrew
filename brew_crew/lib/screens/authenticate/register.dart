import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthServices _auth = AuthServices(); //class AuthServices diambil dari auth.dart
  final _formKey = GlobalKey<FormState>();  //untuk kepentingan validasi form
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ]
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null, //jika mereturn ke null berarti sudah valid
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration : textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ char long' : null, //jika mereturn ke null berarti sudah valid
                onChanged: (val) {
                  setState(() => password = val );
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() => loading = true);
                  // percabangan berikut nilainya true or false. tau true dari mana? kalo validator di TextFormField di atas mereturn ke null
                  //untuk pakai method .validate() ini, maka kita butuh validator di TextFormFieldnya, sudah di deklarasikan di atas
                  if(_formKey.currentState.validate()){ //Jika true berarti kita punya form yang valid. 
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null){ //jika gagal register di firebase dikarenakan penulisan email / passwordnya tidak benar
                      setState(() {
                        error = 'please supply a valid email';
                        loading = false; 
                      });
                    }
                  } 
                }
              ),
              SizedBox(height: 12.0),
              Text( //menampilkan error jika gagal register di firebase dikarenakan penulisan email / passwordnya tidak benar
                error,  
                style: TextStyle(color: Colors.red, fontSize: 14.0)
              )
            ],
          ),
        )
      )
    );
  }
}