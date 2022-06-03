import 'package:acroworld/graphql/mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({required this.cId, Key? key}) : super(key: key);
  final String cId;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  bool isLoading = false;
  final _controller = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(Mutations
            .insertCommunityMessage), // this is the mutation string you just created
        onCompleted: (dynamic resultData) {
          if (resultData['insert_community_messages']['affected_rows'] == 1) {
            _controller.clear();
            FocusScope.of(context).unfocus();
          }
          isLoading = false;
        },
      ),
      builder: (MultiSourceResult<Object?> Function(Map<String, dynamic>,
                  {Object? optimisticResult})
              runMutation,
          QueryResult<Object?>? result) {
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
                      isDense:
                          true, // this will remove the default content padding
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
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    )
                  : IconButton(
                      onPressed: message.trim().isEmpty
                          ? null
                          : () {
                              isLoading = true;
                              runMutation({
                                'content':
                                    message.replaceAll(RegExp(r'\n+'), '\n'),
                                'communityId': widget.cId
                              });
                            },
                      icon: const Icon(Icons.send),
                    ),
            ],
          ),
        );
      },
    );
  }
}
