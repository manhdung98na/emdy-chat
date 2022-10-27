import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  late String fullName;
  final String email;
  late Uint8List? avatar;

  User({required this.id, required this.fullName, required this.email});

  factory User.fromSnapshot(DocumentSnapshot doc) =>
      User(id: doc.id, fullName: doc.get('fullName'), email: doc.get('email'));

  @override
  String toString() {
    return 'ID: $id, name: $fullName, email: $email';
  }
}
