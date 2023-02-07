

import 'package:foody/model/user_model.dart';

class ChatsModel {
  final List ids;
  final UserModel sender;
  final bool userStatus;
  final UserModel resender;

  ChatsModel({
    required this.userStatus,
    required this.ids,
    required this.sender,
    required this.resender,
  });

  factory ChatsModel.fromJson({
    required Map data,
    Map<String, dynamic>? sender,
    Map<String, dynamic>? resender,
    required bool isOnline,
  }) {
    return ChatsModel(
      ids: data["ids"],
      sender: UserModel.fromJson(sender),
      resender: UserModel.fromJson(resender),
      userStatus: isOnline,
    );
  }
}
