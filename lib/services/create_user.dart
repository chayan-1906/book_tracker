import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUser({BuildContext context, String displayName}) async {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser.uid;
  Map<String, dynamic> user = {
    'avatar_url': null,
    'display_name': displayName,
    'profession': 'nope',
    'quote': 'Life is great',
    'uid': uid,
  };
  userCollectionReference.add(user);
}
