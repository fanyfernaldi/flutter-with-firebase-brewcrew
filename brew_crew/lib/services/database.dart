import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  // fungsi ini digunakan pada 2 kasus, saat user register dan saat user mengedit datanya
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name' : name,
      'strength' : strength,
    });
  }

  // brew list from snapshot || analoginya sama dengan _userFromFirebaseUser pada file auth.dart, sama2 menerapkan models
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Brew(  //menggunakan model Brew pada models/brew.dart
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '0'
      );
    }).toList();
  }

  // userData from snapshot || analoginya sama dengan _brewListFromSnapshot di atas, sama2 menerapkan models
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData( //menggunakan model UserData pada models/user.dart
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength']
    );
  }

  // get brews stream langsung dari firestore || dibuat untuk mengakses data pada brews collection yang ada di firestore
  //Stream<QuerySnapshot> get brews { //QuerySnapshot ini dari package firestore
  //  return brewCollection.snapshots(); //method snapshot ini dari package firestore
  //}

  // get brews stream dari firestore yang datanya sudah disimpan dalam List<Brew> di atas ||analoginya sama seperti Stream yang ada di file auth.dart
  Stream<List<Brew>> get brews {  //StreamProvidernya ada di home.dart
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }

  // get user doc stream || StreamBuildernyada di setting_form.dart
  Stream<UserData> get userData { //karena kita pakai custom objek / pake model userData, maka yang tadinya Stream<DocumentSnapshot> diganti menjadi Stream<UserData>
    return brewCollection.document(uid).snapshots() //kalo ngga pake model, sampe sini aja trus ;
      .map(_userDataFromSnapshot);  //karena kita pakai custom objek /pake model userData, maka di mapping ke fungsi _userDataFromSnapshot yang sudah dibuat di atas
  }

}