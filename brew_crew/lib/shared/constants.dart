import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Colors.white, //membuat background warna putih
  filled: true, //agar background putihnya muncul maka filled harus true
  enabledBorder: OutlineInputBorder( //hanya tereksekusi jika form ini di tidak klik / tidak in focus
    borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder( //hanya tereksekusi jika form ini di klik / in focus
    borderSide: BorderSide(color: Colors.pink, width: 2.0)
  )
);