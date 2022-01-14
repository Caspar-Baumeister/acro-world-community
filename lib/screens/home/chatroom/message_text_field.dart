import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.activeUser!;
    await DataBaseService(uid: user.uid).updateMessageData(
        cid: widget.cId,
        message: message,
        username: user.userName ?? "user",
        imgUrl: user.imgUrl ?? MORTY_IMG_URL);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}
