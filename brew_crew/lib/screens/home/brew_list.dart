import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';


class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {

    // mengakses data dari stream ngga pake model
    // final brews = Provider.of<QuerySnapshot>(context);
    // // print(brews.documents);  //ngeprint nama document dari collection brews
    // for (var doc in brews.documents){ //ngeprint setiap data yang ada di documents milik collection brew
    //   print(doc.data);
    // } 

    // mengakses data dari stream pake model Brew
    // final brews = Provider.of<List<Brew>>(context);
    // brews.forEach((brew){
    //   print(brew.name);
    //   print(brew.sugars);
    //   print(brew.strength);
    // });

    // mengakses data dari stream dan menampilkannya ke layar
    final brews = Provider.of<List<Brew>>(context) ?? [];

    return ListView.builder(
      itemCount: brews.length,
      itemBuilder: (context, index) { //index disini nilainya dimulai dari 0
        return BrewTile(brew: brews[index]);
      }
    );
  }
}