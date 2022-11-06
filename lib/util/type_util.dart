enum PasswordHeath { mustHave6Character, weak, good, strong }

enum BorderType { none, underline, outline }

class RecentActionType {
  RecentActionType._();

  static const int sentMessage = 1;
  static const int sentSticker = 2;
  static const int sentMedia = 3;
  static const int react = 4;
}

class ChatType {
  ChatType._();

  static const int individual = 1;
  static const int group = 2;
  static const int private = 3;
}

class ChatStatus {
  ChatStatus._();

  static const int block = -1;
  static const int ignored = 0;
  static const int accepted = 1;
  static const int waiting = 2;
}

class MessageType {
  MessageType._();

  static const int text = 1;
  static const int picture = 2;
  static const int video = 3;
}

class ReactionType {
  ReactionType._();
  static const List<int> listReact = [like, love, haha, sad, wow, angry];

  static const int noReact = 0;
  static const int like = 1;
  static const int love = 2;
  static const int haha = 3;
  static const int sad = 4;
  static const int wow = 5;
  static const int angry = 6;
}
