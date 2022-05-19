import 'package:acroworld/provider/user_provider.dart';
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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    //UserModel user = userProvider.activeUser!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
                //color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: TextField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  isDense: true, // this will remove the default content padding

                  contentPadding: EdgeInsets.only(bottom: 10.0, left: 8.0),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  labelText: "send message ...",
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
    String sendMessage = message;
    _controller.clear();
    FocusScope.of(context).unfocus();
    //   await DataBaseService(uid: user.uid).addMessageData(
    //       cid: widget.cId,
    //       message: sendMessage,
    //       username: user.userName ?? "user",
    //       imgUrl: user.imgUrl ?? "");
  }
}
