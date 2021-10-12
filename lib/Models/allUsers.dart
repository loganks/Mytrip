import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class Users
{
  String id;
  String email;
  String nom;
  String telephone;
  String nature;

  Users({this.id, this.email, this.nom, this.telephone, this.nature});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id=dataSnapshot.key;
    email= dataSnapshot.value["email"];
    nom= dataSnapshot.value["nom"];
    telephone= dataSnapshot.value["telephone"];
    nature = dataSnapshot.value["nature"];
  }

}