import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../model/chats_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';
import 'local_sotre/local_store.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _image = ImagePicker();
  List<UserModel> users = [];
  List<ChatsModel> chats = [];
  List<MessageModel> messages = [];
  List listOfDocIdChats = [];
  List listOfDocIdUser = [];
  String userId = "";
  bool addUser = false;
  bool isLoading = true;
  bool isUploading = false;
  String editMessId = "";
  String oldText = "";
  int? selectReplyIndex;
  DateTime? editTime;

  changeEditText(
      {required String messId,
      required String oldText,
      required DateTime time}) {
    editMessId = messId;
    editTime = time;
    this.oldText = oldText;
  }

  changeAddUser() {
    addUser = !addUser;
    notifyListeners();
  }

  getUserList() async {
    var res = await firestore.collection("users").get();
    String? userId = await LocalStore.getDocId();
    users.clear();
    listOfDocIdUser.clear();

    for (var element in res.docs) {
      if (userId != element.id) {
        users.add(UserModel.fromJson(element.data()));
        listOfDocIdUser.add(element.id);
      }
    }
    notifyListeners();
  }

  getChatsList() async {
    var res = await firestore
        .collection("chats")
        .where("ids", arrayContainsAny: [await LocalStore.getDocId()]).get();
    for (var element in res.docs) {
      int ownerIndex =
          (element.data()["ids"] as List).indexOf(await LocalStore.getDocId());

      firestore.collection("chats").doc(element.id).update({
        "ids": [
          (element.data()["ids"] as List)[0],
          (element.data()["ids"] as List)[1]
        ],
        "onlines": ownerIndex == 0
            ? [true, (element.data()["onlines"] as List)[1]]
            : [(element.data()["onlines"] as List)[0], true]
      });
    }
    firestore
        .collection("chats")
        .where("ids", arrayContainsAny: [await LocalStore.getDocId()])
        .snapshots()
        .listen((res) async {
          listOfDocIdChats.clear();
          chats.clear();
          for (var element in res.docs) {
            int ownerIndex = (element.data()["ids"] as List)
                .indexOf(await LocalStore.getDocId());
            var resUser = await firestore
                .collection("users")
                .doc((element.data()["ids"] as List)[ownerIndex == 0 ? 1 : 0])
                .get();
            chats.add(ChatsModel.fromJson(
                data: element.data(),
                resender: resUser.data(),
                isOnline: (element.data()["onlines"]
                        ?[ownerIndex == 0 ? 1 : 0]) ??
                    false));
            listOfDocIdChats.add(element.id);
          }
          notifyListeners();
        });
  }

  getMessages(String docId) async {
    isLoading = true;
    notifyListeners();
    userId = await LocalStore.getDocId() ?? "";
    messages.clear();
    firestore
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .snapshots()
        .listen((res) async {
      messages.clear();
      for (var element in res.docs) {
        messages.add(
          MessageModel.fromJson(
            data: element.data(),
            messId: element.id,
            replyData: element.data()["replyMessage"],
          ),
        );
      }
      messages.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }

  createChat(int index, ValueChanged<String> onSuccess) async {
    List list = [];
    for (var element in chats) {
      list.addAll(element.ids);
    }

    if (!list.contains(listOfDocIdUser[index])) {
      var res = await firestore.collection("chats").add({
        "ids": [listOfDocIdUser[index], await LocalStore.getDocId()],
        "onlines": [false, true]
      });
      onSuccess(res.id);
    } else {
      for (int i = 0; i < chats.length; i++) {
        if (chats[i].ids.contains(listOfDocIdUser[index])) {
          onSuccess(listOfDocIdChats[i]);
        }
      }
    }
  }

  sendMessage(
      {required String title,
      required String docId,
      required String type}) async {
    firestore
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .add(MessageModel(
          title: title,
          time: DateTime.now(),
          ownerId: await LocalStore.getDocId() ?? "",
          messId: '',
          type: type,
        ).toJson(
            reply:
                selectReplyIndex != null ? messages[selectReplyIndex!] : null));
    selectReplyIndex = null;
    notifyListeners();
  }

  deleteMessage({required String chatDocId, required String messDocId}) {
    firestore
        .collection("chats")
        .doc(chatDocId)
        .collection("messages")
        .doc(messDocId)
        .delete();
  }

  editMessage(
      {required String chatDocId,
      required String messDocId,
      required String newMessage,
      required DateTime time}) {
    if (newMessage != oldText) {
      firestore
          .collection("chats")
          .doc(chatDocId)
          .collection("messages")
          .doc(messDocId)
          .update(MessageModel(
            title: newMessage,
            time: time,
            ownerId: userId,
            messId: "",
            type: "text",
          ).toJson());
    }
    editTime = null;
  }

  setOffline() async {
    var res = await firestore
        .collection("chats")
        .where("ids", arrayContainsAny: [await LocalStore.getDocId()]).get();
    for (var element in res.docs) {
      int ownerIndex =
          (element.data()["ids"] as List).indexOf(await LocalStore.getDocId());

      firestore.collection("chats").doc(element.id).update({
        "ids": [
          (element.data()["ids"] as List)[0],
          (element.data()["ids"] as List)[1]
        ],
        "onlines": ownerIndex == 0
            ? [false, (element.data()["onlines"] as List)[1]]
            : [(element.data()["onlines"] as List)[0], false]
      });
    }
  }

  getImageGallery(String docId) {
    _image
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        var imagePath = cropperImage?.path ?? "";
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("chats/image/${DateTime.now().toString()}");
        isUploading = true;
        notifyListeners();
        await storageRef.putFile(File(imagePath));
        var res = await storageRef.getDownloadURL();
        sendMessage(title: res, docId: docId, type: "image");
        isUploading = false;
        notifyListeners();
      }
    });
  }

  getVideoGallery(String docId) {
    _image
        .pickVideo(
      source: ImageSource.gallery,
    )
        .then((value) async {
      if (value != null) {
        var imagePath = value.path;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("chats/video/${DateTime.now().toString()}");
        isUploading = true;
        notifyListeners();
        await storageRef.putFile(File(imagePath));
        var res = await storageRef.getDownloadURL();
        sendMessage(title: res, docId: docId, type: "video");
        isUploading = false;
        notifyListeners();
      }
    });
  }

  onReply(int? index) {
    selectReplyIndex = index;
    notifyListeners();
  }
}
