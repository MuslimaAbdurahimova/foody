import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';
import 'local_sotre/local_store.dart';

class AuthController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _image = ImagePicker();
  UserModel? userModel;
  String verificationId = '';
  String phone = "";
  String? errorText;
  String imagePath = "";
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool isFacebookLoading = false;

  Future<bool> checkPhone(String phone) async {
    try {
      var res = await firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();
      if (res.docs.first != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  sendSms(String phone, VoidCallback codeSend) async {
    isLoading = true;
    errorText = null;
    notifyListeners();
    if (await checkPhone(phone)) {
      errorText = "bu nomer ga uje account ochilgan";
      isLoading = false;
      notifyListeners();
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          print(credential.toString());
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          this.phone = phone;
          isLoading = false;
          notifyListeners();
          codeSend();
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  checkCode(String code, VoidCallback onSuccess) async {
    isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);

      var res = await FirebaseAuth.instance.signInWithCredential(credential);
      isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      print(e);
    }
  }

  setStateUser(
      {required String name,
      required String username,
      required String password,
      required String email,
      required String gender,
      required String birth,
      required VoidCallback onSuccess}) {
    userModel = UserModel(
      name: name,
      username: username,
      password: password,
      email: email,
      gender: gender,
      phone: phone,
      birth: birth,
    );
    onSuccess();
  }

  login(String phone, String password, VoidCallback onSuccess) async {
    isLoading = true;
    errorText = null;
    notifyListeners();
    try {
      var res = await firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();
      if (res.docs.first["password"] == password) {
        LocalStore.setDocId(res.docs.first.id);
        onSuccess();
        isLoading = false;
        notifyListeners();
      } else {
        errorText =
            "Password xatto bolishi mumkin yoki bunaqa nomer bn sign up qilinmagan";
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorText =
          "Password xatto bolishi mumkin yoki bunaqa nomer bn sign up qilinmagan";
      isLoading = false;
      notifyListeners();
    }
  }

  getImageCamera() {
    _image.pickImage(source: ImageSource.camera).then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        imagePath = cropperImage?.path ?? "";
        notifyListeners();
      }
    });
    notifyListeners();
  }

  getImageGallery() {
    _image.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        imagePath = cropperImage?.path ?? "";
        notifyListeners();
      }
    });
    notifyListeners();
  }

  createUser(VoidCallback onSuccess) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("avatars/${DateTime.now().toString()}");
    await storageRef.putFile(File(imagePath ?? ""));

    String url = await storageRef.getDownloadURL();

    firestore
        .collection("users")
        .add(UserModel(
                name: userModel?.name ?? "",
                username: userModel?.username ?? "",
                password: userModel?.password ?? "",
                email: userModel?.email ?? "",
                gender: userModel?.gender ?? "",
                phone: userModel?.phone ?? "",
                birth: userModel?.birth ?? "",
                avatar: url)
            .toJson())
        .then((value) async {
      await LocalStore.setDocId(value.id);
      onSuccess();
    });
  }

  loginGoogle(VoidCallback onSuccess) async {
    isGoogleLoading = true;
    notifyListeners();
    GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userObj =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userObj.additionalUserInfo?.isNewUser);
    if (userObj.additionalUserInfo?.isNewUser ?? true) {
      // sing in
      firestore
          .collection("users")
          .add(UserModel(
                  name: userObj.user?.displayName ?? "",
                  username: userObj.user?.displayName ?? "",
                  password: userObj.user?.uid ?? "",
                  email: userObj.user?.email ?? "",
                  gender: "",
                  phone: userObj.user?.phoneNumber ?? "",
                  birth: "",
                  avatar: userObj.user?.photoURL ?? "")
              .toJson())
          .then((value) async {
        await LocalStore.setDocId(value.id);
        onSuccess();
        _googleSignIn.signOut();
      });
    } else {
      // sing up
      var res = await firestore
          .collection("users")
          .where("email", isEqualTo: userObj.user?.email)
          .get();

      if (res.docs.isNotEmpty) {
        await LocalStore.setDocId(res.docs.first.id);
        onSuccess();
      }
    }

    isGoogleLoading = false;
    notifyListeners();
  }

  loginFacebook(VoidCallback onSuccess) async {
    isFacebookLoading = true;
    notifyListeners();

    final fb = FacebookLogin();

    final user = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);

    final OAuthCredential credential =
        FacebookAuthProvider.credential(user.accessToken?.token ?? "");

    final userObj =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userObj.additionalUserInfo?.isNewUser ?? true) {
      // sing in
      firestore
          .collection("users")
          .add(UserModel(
                  name: userObj.user?.displayName ?? "",
                  username: userObj.user?.displayName ?? "",
                  password: userObj.user?.uid ?? "",
                  email: userObj.user?.email ?? "",
                  gender: "",
                  phone: userObj.user?.phoneNumber ?? "",
                  birth: "",
                  avatar: userObj.user?.photoURL ?? "")
              .toJson())
          .then((value) async {
        await LocalStore.setDocId(value.id);
        onSuccess();
      });
    } else {
      // sing up
      var res = await firestore
          .collection("users")
          .where("email", isEqualTo: userObj.user?.email)
          .get();

      if (res.docs.isNotEmpty) {
        await LocalStore.setDocId(res.docs.first.id);
        onSuccess();
      }
    }

    isFacebookLoading = false;
    notifyListeners();
  }
}
