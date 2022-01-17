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
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
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
                // now you can customize it here or add padding widget
                contentPadding: EdgeInsets.only(bottom: 10.0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none,
                labelText: "Message",
              ),
              onChanged: (value) => setState(() {
                message = value;
              }),
            ),
          ),
        ),
        IconButton(
          onPressed: message.trim().isEmpty ? null : () async => sendMessage(),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }

  Future<void> sendMessage() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.activeUser!;
    await DataBaseService(uid: user.uid).addMessageData(
        cid: widget.cId,
        message: message,
        username: user.userName ?? "user",
        imgUrl: user.imgUrl ?? MORTY_IMG_URL);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}
