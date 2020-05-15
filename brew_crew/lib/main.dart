import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  //kita pakai provider untuk provide stream sehingga bisa didengarkan oleh widget dibawahnya
import 'package:brew_crew/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(  
      value: AuthServices().user,  //what stream we actually want to listen and what data do we expect to get back
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
