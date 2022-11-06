import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  /// ID của DocumentSnapshot. Cố định, được tạo ra khi người dùng đăng kí vào hệ thống và không thể thay đổi
  final String id;

  /// ID của người dùng. Người dùng có thể chọn và thay đổi, nhưng không được trùng với người khác
  final String userId;

  /// Họ tên của người dùng
  late String fullName;

  /// Email người dùng đăng ký
  final String email;

  /// Trả về `true` nếu người dùng có ảnh đại diện, và `false` nếu không có
  late bool hasAvatar;

  /// Ảnh đại diện của người dùng
  late Uint8List? avatar;

  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.userId,
      required this.avatar,
      required this.hasAvatar});

  factory User.fromSnapshot(DocumentSnapshot doc) => User(
        id: doc.id,
        fullName: doc.get('fullName'),
        email: doc.get('email'),
        userId: doc.get('userId'),
        avatar: null,
        hasAvatar: doc.get('hasAvatar'),
      );

  @override
  String toString() {
    return 'ID: $id, name: $fullName, email: $email, userId = $userId';
  }
}
