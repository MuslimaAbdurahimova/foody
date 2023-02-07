import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';

import '../../model/message_model.dart';

class MessageItem extends StatelessWidget {
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onReply;
  final VoidCallback onDelete;
  final MessageModel message;

  const MessageItem(
      {Key? key,
      required this.isOwner,
      required this.onEdit,
      required this.onReply,
      required this.onDelete,
      required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      blurSize: 10,
      duration: const Duration(milliseconds: 300),
      onPressed: () {},
      menuItems: isOwner
          ? [
              FocusedMenuItem(title: Text("Reply"), onPressed: onReply),
              FocusedMenuItem(title: Text("Edit"), onPressed: onEdit),
              FocusedMenuItem(title: const Text("Delete"), onPressed: onDelete),
            ]
          : [
              FocusedMenuItem(title: Text("Reply"), onPressed: onReply),
              FocusedMenuItem(title: const Text("Delete"), onPressed: onDelete),
            ],
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isOwner ? Colors.pinkAccent : Colors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.replyMessage != null
                ? IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      (message.replyMessage?.title.length ?? 0) > 30 ? SizedBox(
                        width: 200,
                        child: Text(
                          message.replyMessage?.title ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style:
                          TextStyle(color: isOwner ? Colors.white : Colors.black),
                        ),
                      ) : Text(
                        message.replyMessage?.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(color: isOwner ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                )
                : const SizedBox.shrink(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                message.title.length > 20 ?  SizedBox(
                  width: 100,
                  child: Text(
                    message.title,
                    style:
                        TextStyle(color: isOwner ? Colors.white : Colors.black),
                  ),
                ) : Text(
                  message.title,
                  style:
                  TextStyle(color: isOwner ? Colors.white : Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    DateFormat("hh:mm").format(message.time),
                    style: TextStyle(
                        color: isOwner ? Colors.white : Colors.black,
                        fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
