import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/type_util.dart';

class Chat {
  late final String _id;

  /// Ảnh đại diện
  late bool avatar;

  /// Danh sách ID của các thành viên trong đoạn chat
  late Set<String> members;

  /// Tên đoạn chat
  late String name;

  /// Biệt danh của các thành viên
  late Map<String, String> nicknames;

  /// Hành động mới nhất
  ///
  /// * Gửi tin nhắn [RecentActionType.sentMessage]
  /// * Gửi hình ảnh [RecentActionType.sentMedia]
  /// * Gửi nhãn dãn [RecentActionType.sentSticker]
  /// * Bày tỏ cảm xúc [RecentActionType.react]
  late int _recentAction;

  /// Người vừa thực hiện [recentAction]
  late String recentActorId;

  /// Thời điển thực hiện [recentAction]
  late DateTime recentTime;

  /// Kiểu đoạn chat:
  /// * [ChatType.group]
  /// * [ChatType.individual]
  /// * [ChatType.private]
  late int type;

  /// Tình trạng của đoạn chat, được lưu theo dạng Map với
  /// key là ID của [members] và value là giá trị status
  /// * [ChatStatus.block] = ``-1``
  /// * [ChatStatus.ignored] = ``0``
  /// * [ChatStatus.accepted] = ``1``
  /// * [ChatStatus.waiting] = ``2``
  /// #### Ví dụ:
  /// * 'idOfMember1': 1,
  /// * 'idOfMember2': -1.
  ///
  /// Có nghĩa là member 1 đã chấp nhận đoạn tin nhắn. Và member 2 đã block đoạn tin nhắn này
  late Map<String, int> _status;

  /// Nội dung các tin nhắn của đoạn chat
  late List<Message> messages = [];

  Chat(
    this._id, {
    required this.avatar,
    required this.members,
    required this.name,
    required this.nicknames,
    required int recentAction,
    required this.recentActorId,
    required this.recentTime,
    required this.type,
    required Map<String, dynamic> status,
  }) {
    _recentAction = recentAction;
    _status = status.cast();
  }

  Chat.fromDocumentSnapshot(DocumentSnapshot doc) {
    _id = doc.id;
    avatar = doc.get('avatar');
    members = doc.get('members').cast<String>().toSet();
    name = doc.get('name');
    nicknames = (doc.get('nicknames') as Map).cast<String, String>();
    _recentAction = doc.get('recentAction');
    recentActorId = doc.get('recentActor');
    recentTime = (doc.get('recentTime') as Timestamp).toDate();
    type = doc.get('type');
    _status = (doc.get('status') as Map).cast<String, int>();
  }

  String get id => _id;

  String get recentAction {
    switch (_recentAction) {
      case RecentActionType.react:
        return 'reacted your message';
      case RecentActionType.sentMessage:
        return 'sent a message';
      case RecentActionType.sentMedia:
        return 'sent a picture';
      case RecentActionType.sentSticker:
        return 'sent a sticker';
      default:
        throw Exception('Wrong RecentActionType: $_recentAction');
    }
  }

  String get recentActorName => nicknames[recentActorId]!;

  int get status => _status[UserManager.uid] ?? -100;

  set status(int newStatus) => _status[UserManager.uid!] = newStatus;

  String getSenderNameById(String senderId) => nicknames[senderId]!;

  /// ID của người đang chat cùng
  String get theOppositeId => members.firstWhere((e) => e != UserManager.uid);

  void copyFrom(Chat other) {
    name = other.name;
    avatar = other.avatar;
    members = other.members;
    name = other.name;
    nicknames = other.nicknames;
    _recentAction = other._recentAction;
    recentActorId = other.recentActorId;
    recentTime = other.recentTime;
    type = other.type;
    _status = other._status;
  }

  Future<String> updateStatus(int newStatus) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(id)
        .update({'status.${UserManager.uid}': newStatus})
        .then((value) => success)
        .onError((error, stackTrace) => error.toString());
  }

  Future<String> updateName(String newName) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(id)
        .update({'name': newName}).then((value) {
      return success;
    }).onError((error, stackTrace) => error.toString());
  }

  Future<String> updateNickname(Map<String, String> newNickname) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(id)
        .update({'nicknames': newNickname})
        .then((value) => success)
        .onError((error, stackTrace) => error.toString());
  }

  Future<String> delete() async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(id)
        .delete()
        .then((value) => success)
        .onError((error, stackTrace) => error.toString());
  }

  @override
  String toString() {
    return 'ChatName: $name, members: ${members.toString()}, nickname: $nicknames';
  }
}
