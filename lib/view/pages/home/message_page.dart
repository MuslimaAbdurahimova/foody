import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controller/chat_controller.dart';
import '../../../model/user_model.dart';
import '../../component/custom_network_image.dart';
import '../../component/custom_text_from.dart';
import '../../component/custom_video.dart';
import '../../component/diss_keboard.dart';
import '../../component/message_item.dart';

class MessagePage extends StatefulWidget {
  final String docId;
  final UserModel user;

  const MessagePage({Key? key, required this.docId, required this.user})
      : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController message = TextEditingController();
  final FocusNode messageNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().getMessages(widget.docId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatController>();
    final event = context.read<ChatController>();
    return OnUnFocusTap(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              widget.user.avatar == null
                  ? const SizedBox.shrink()
                  : ClipOval(
                      child: Image.network(
                        widget.user.avatar ?? "",
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                      ),
                    ),
              Text(widget.user.name ?? ""),
            ],
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(24),
                reverse: true,
                itemCount: state.isUploading
                    ? state.messages.length + 1
                    : state.messages.length,
                itemBuilder: (context, index) {
                  return (state.isUploading && (index == 0))
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey,
                          ),
                        )
                      : Align(
                          alignment: state
                                      .messages[
                                          state.isUploading ? index - 1 : index]
                                      .ownerId ==
                                  state.userId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: state
                                      .messages[
                                          state.isUploading ? index - 1 : index]
                                      .type ==
                                  "text"
                              ? MessageItem(
                                  onReply: () {
                                    event.onReply(index);
                                  },
                                  isOwner: state
                                          .messages[state.isUploading
                                              ? index - 1
                                              : index]
                                          .ownerId ==
                                      state.userId,
                                  onEdit: () {
                                    message.text = state
                                        .messages[state.isUploading
                                            ? index - 1
                                            : index]
                                        .title;
                                    FocusScope.of(context)
                                        .autofocus(messageNode);
                                    event.changeEditText(
                                        messId: state
                                            .messages[state.isUploading
                                                ? index - 1
                                                : index]
                                            .messId!,
                                        time: state
                                            .messages[state.isUploading
                                                ? index - 1
                                                : index]
                                            .time,
                                        oldText: state
                                            .messages[state.isUploading
                                                ? index - 1
                                                : index]
                                            .title);
                                  },
                                  onDelete: () {
                                    event.deleteMessage(
                                        chatDocId: widget.docId,
                                        messDocId: state
                                            .messages[state.isUploading
                                                ? index - 1
                                                : index]
                                            .messId!);
                                  },
                                  message: state.messages[
                                      state.isUploading ? index - 1 : index],
                                )
                              : state
                                          .messages[state.isUploading
                                              ? index - 1
                                              : index]
                                          .type ==
                                      "image"
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: CustomImageNetwork(
                                        image: state
                                            .messages[state.isUploading
                                                ? index - 1
                                                : index]
                                            .title,
                                        height: 100,
                                        width: 100,
                                        radius: 16,
                                      ),
                                    )
                                  : CustomVideo(
                                      videoUrl: state
                                          .messages[state.isUploading
                                              ? index - 1
                                              : index]
                                          .title,
                                    ),
                        );
                }),
        bottomNavigationBar: Container(
          padding:
              const EdgeInsets.only(bottom: 12, left: 24, right: 24, top: 12),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state.selectReplyIndex == null
                  ? const SizedBox.shrink()
                  : IntrinsicHeight(
                      child: Row(
                        children: [
                          const Icon(Icons.replay),
                          const VerticalDivider(
                            color: Colors.pinkAccent,
                            thickness: 2,
                          ),
                          Text(state
                              .messages[state.selectReplyIndex ?? 0].title),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                event.onReply(null);
                              },
                              icon: const Icon(Icons.cancel_outlined))
                        ],
                      ),
                    ),
              CustomTextFrom(
                node: messageNode,
                controller: message,
                label: "",
                prefixIcon: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          event.getImageGallery(widget.docId);
                        },
                        icon: const Icon(Icons.image),
                      ),
                      IconButton(
                        onPressed: () {
                          event.getVideoGallery(widget.docId);
                        },
                        icon: const Icon(Icons.video_library),
                      ),
                    ],
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    state.editTime != null
                        ? event.editMessage(
                            chatDocId: widget.docId,
                            messDocId: state.editMessId,
                            newMessage: message.text,
                            time: state.editTime ?? DateTime.now())
                        : event.sendMessage(
                            title: message.text,
                            docId: widget.docId,
                            type: 'text');
                    message.clear();
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
