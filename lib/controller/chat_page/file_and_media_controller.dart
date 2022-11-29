import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FileAndMediaController extends ChangeNotifier {
  FileAndMediaController(this.chat) {
    indexScreen = 0;
    isLoading = true;
    images = [];
    videos = [];
    getMedia();
  }

  /// Current chat. For getting its media
  final Chat chat;

  /// List of images in Firebase Storage
  late List<String> images;

  /// List of videos in Firebase Storage
  late List<String?> videos;

  /// Whether still loading images and videos or not
  late bool isLoading;

  /// Index of screen:
  ///
  /// * 0: Images screen
  /// * 1: Videos screen
  late int indexScreen;

  /// Get images and videos from Firebase Storage
  Future<void> getMedia() async {
    bool finishLoadingImg = false, finishLoadingVid = false;
    // Load image
    FirebaseStorage.instance
        .ref(
            '${FirebaseManager.messagesStorage}/${chat.id}/${FirebaseManager.imageStorage}')
        .listAll()
        .then((value) async {
      for (var element in value.items) {
        images.add(await element.getDownloadURL());
      }
      finishLoadingImg = true;
      if (finishLoadingVid) {
        isLoading = false;
        notifyListeners();
      }
    });
    // Load video
    FirebaseStorage.instance
        .ref(
            '${FirebaseManager.messagesStorage}/${chat.id}/${FirebaseManager.videoStorage}')
        .listAll()
        .then((value) async {
      for (var element in value.items) {
        videos.add(await element.getDownloadURL());
      }
      finishLoadingVid = true;
      if (finishLoadingImg) {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  /// Change screen to the new one
  void switchScreen(int newIndex) {
    if (indexScreen == newIndex) {
      return;
    }
    indexScreen = newIndex;
    notifyListeners();
  }
}
