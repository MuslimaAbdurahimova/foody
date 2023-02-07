class MessageModel {
  final String title;
  final DateTime time;
  final String ownerId;
  final String? messId;
  final String? type;
  final MessageModel? replyMessage;

  MessageModel(
      {required this.title,
      required this.time,
      required this.ownerId,
      required this.messId,
      required this.type,
      this.replyMessage});

  factory MessageModel.fromJson(
      {required Map? data,
      required String? messId,
      Map? replyData,
      String? replyMessId}) {
    return MessageModel(
      title: data?["title"],
      time: DateTime.parse(data?["time"]),
      ownerId: data?["ownerId"],
      messId: messId,
      type: data?["type"] ?? "text",
      replyMessage: replyData != null
          ? MessageModel.fromJson(data: replyData, messId: replyMessId)
          : null,
    );
  }

  toJson({MessageModel? reply}) {
    return {
      "title": title,
      "time": time.toString(),
      "ownerId": ownerId,
      "type": type,
      if (reply != null) "replyMessage": reply.toJson(),
    };
  }
}
