import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Đối tượng đại diện cho mỗi tin nhắn được gửi đi
class Message {
  /// ID của đoạn chat chứa tin nhắn hiện tại
  late String chatId;

  /// ID của tin nhắn
  late String id;

  /// Nội dung của tin nhắn
  /// * [MessageType.text] thì nội dung là đoạn text được gửi
  /// * [MessageType.picture] hoặc [MessageType.video] thì nội dung là đường dẫn của ảnh/video đó
  late String? content;

  /// ID của người gửi
  late String senderId;

  /// Thời điểm gửi
  late DateTime time;

  /// Kiểu tin nhắn
  /// * [MessageType.text] = ``1``
  /// * [MessageType.picture] = ``2``
  /// * [MessageType.video] = ``3``
  late int type;

  /// Thả cảm xúc tin nhắn. Lưu dưới dạng map: key là ID người dùng, value là cảm xúc
  ///
  /// Giá trị là 1 trong [ReactionType.listReact]
  late Map<String, int> react;

  Message(this.id, this.chatId, this.content, this.senderId, this.time,
      this.type, this.react);

  Message.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    id = doc.id;
    chatId = docData['chatId'];
    content = docData['content'];
    senderId = docData['senderId'];
    time = (docData['time'] as Timestamp).toDate();
    type = docData['type'];
    if (docData.containsKey('react')) {
      react = docData['react'].cast<String, int>();
    } else {
      react = {};
    }
  }

  /// Thả cảm xúc cho tin nhắn
  Future<bool> updateReaction(int type) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(chatId)
        .collection(FirebaseManager.messageCollection)
        .doc(id)
        .update({'react.${UserManager.uid!}': type})
        .then((value) => true)
        .onError((error, stackTrace) {
          print(error);
          return false;
        });
  }

  /// Xóa cảm xúc đã thả
  Future<bool> removeReaction() async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(chatId)
        .collection(FirebaseManager.messageCollection)
        .doc(id)
        .update({'react.${UserManager.uid!}': FieldValue.delete()})
        .then((value) => true)
        .onError((error, stackTrace) {
          print(error);
          return false;
        });
  }

  /// Xóa tin nhắn
  Future<void> delete() async {
    await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(chatId)
        .collection(FirebaseManager.messageCollection)
        .doc(id)
        .delete();
    switch (type) {
      case MessageType.picture:
        FirebaseStorage.instance
            .ref(
                '${FirebaseManager.messagesStorage}/$chatId/${FirebaseManager.imageStorage}/$id')
            .delete();
        break;
      case MessageType.video:
        FirebaseStorage.instance
            .ref(
                '${FirebaseManager.messagesStorage}/$chatId/${FirebaseManager.videoStorage}/$id')
            .delete();
        break;
      default:
    }
  }

  @override
  String toString() {
    return '$senderId sent at ${time.toString()} ($type): $content';
  }
}
