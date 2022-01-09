import 'package:acroworld/models/message_model.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({required this.cId, Key? key}) : super(key: key);

  final String cId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: MessagesWidget(cid: cId),
            ),
          ),
          MessageTextField(cId: cId)
        ],
      ),
    );
  }
}

class MessageTextField extends StatefulWidget {
  const MessageTextField({required this.cId, Key? key}) : super(key: key);
  final String cId;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final _controller = TextEditingController();
  String message = "";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: "Type in your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
          ),
          IconButton(
            onPressed:
                message.trim().isEmpty ? null : () async => sendMessage(),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    String userId = UserIdPreferences.getToken();
    print("userid: $userId");
    await DataBaseService(uid: userId).updateMessageData(
        cid: widget.cId, message: message, username: "caspar", imgUrl: "");
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({required this.cid, Key? key}) : super(key: key);
  final String cid;
  @override
  Widget build(BuildContext context) {
    String userId = UserIdPreferences.getToken();
    return StreamBuilder<QuerySnapshot>(
        stream: DataBaseService(uid: userId).getMessages(cid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          List<Message> messages = snapshot.data!.docs.map((e) {
            return Message.fromJson(e.data());
          }).toList();

          print(messages);
          return (messages == null || messages.isEmpty)
              ? buildText("A beautiful new community")
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageWidget(
                        message: message, isMe: message.uid == userId);
                  },
                  reverse: true,
                  itemCount: messages.length,
                  physics: BouncingScrollPhysics(),
                );
        });
    ;
  }

  buildText(String text) {
    return Center(
      child: Text(text),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({required this.message, required this.isMe, Key? key})
      : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(12.0);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(MORTY_IMG_URL),
          ),
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[500] : Colors.grey[50],
              borderRadius: isMe
                  ? borderRadius
                      .subtract(BorderRadius.only(bottomRight: radius))
                  : borderRadius
                      .subtract(BorderRadius.only(bottomLeft: radius)),
            ),
            child: buildMessage()),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black54,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
