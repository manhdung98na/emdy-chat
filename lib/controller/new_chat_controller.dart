import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/user.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class NewChatController extends ChangeNotifier {
  NewChatController() {
    isLoading = false;
    teUserId = TextEditingController();
    foundUsers = [];
    chatPageController = null;
  }

  final int _pageSize = 5;

  /// Cho phép người dùng nhập ID của người nhận tin nhắn
  late TextEditingController teUserId;

  /// Danh sách người dùng khi tìm kiếm bằng cách nhập vào UID
  late List<User> foundUsers;

  late bool isLoading;

  /// DocumentSnapshot được trả về cuối cùng khi giới hạn số record query
  DocumentSnapshot? lastUserSnapshot;

  /// Khi người dùng chọn receiver, [chatPageController] sẽ khác `null`
  ChatPageController? chatPageController;

  Query getQuery() => FirebaseFirestore.instance
      .collection(FirebaseManager.userCollection)
      .where('userId', isGreaterThanOrEqualTo: teUserId.text)
      .orderBy('userId');

  Future<void> searchUserById() async {
    chatPageController = null;
    if (isLoading || teUserId.text.trim().isEmpty) {
      return;
    }
    isLoading = true;
    notifyListeners();
    foundUsers.clear();
    lastUserSnapshot = null;
    QuerySnapshot snapshot = await getQuery().limit(_pageSize).get();
    if (snapshot.size > 0) {
      await getDataFromSnapshot(snapshot);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoading || teUserId.text.trim().isEmpty || lastUserSnapshot == null) {
      return;
    }
    isLoading = true;
    notifyListeners();
    await getQuery()
        .startAfterDocument(lastUserSnapshot!)
        .limit(_pageSize)
        .get()
        .then((snapshot) async {
      if (snapshot.size > 0) {
        await getDataFromSnapshot(snapshot);
      } else {
        lastUserSnapshot = null;
      }
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> getDataFromSnapshot(QuerySnapshot snapshot) async {
    if (snapshot.size < _pageSize) {
      lastUserSnapshot = null;
    } else {
      lastUserSnapshot = snapshot.docs.last;
    }
    for (var doc in snapshot.docs) {
      if (doc.id == UserManager.uid) {
        continue;
      }
      User temp = User.fromSnapshot(doc);
      if (temp.hasAvatar) {
        await FirebaseStorage.instance
            .ref('${FirebaseManager.usersStorage}/${temp.id}')
            .getData()
            .then((value) {
          temp.avatar = value;
        }).onError((error, stackTrace) {
          debugPrint('Not found avatar of ${temp.id}');
        });
      }
      foundUsers.add(temp);
    }
  }

  Future<void> loadChatByReceiverId(String receiverId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .where('members', isEqualTo: [UserManager.uid, receiverId]).get();
    if (snapshot.size > 0) {
      Chat existChat = Chat.fromDocumentSnapshot(snapshot.docs.first);
      chatPageController = ChatPageController(existChat);
    } else {
      User receiver =
          foundUsers.firstWhere((element) => element.id == receiverId);
      Chat newChat = Chat(
        FirebaseManager.randomId(),
        avatar: receiver.hasAvatar,
        members: <String>{UserManager.uid!, receiverId},
        name: receiver.fullName,
        nicknames: {
          UserManager.uid!: UserManager.currentUser?.fullName ?? '',
          receiver.id: receiver.fullName,
        },
        recentAction: null,
        recentActorId: null,
        recentTime: null,
        status: {
          UserManager.uid!: ChatStatus.accepted,
          receiver.id: ChatStatus.waiting,
        },
        type: ChatType.individual,
        isLocal: true,
      );
      chatPageController = ChatPageController(newChat);
    }
    notifyListeners();
  }

  static Future<bool> createNewChat(Chat newChat) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(newChat.id)
        .set(newChat.toMap())
        .then((value) => true)
        .onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
