import 'package:chatapp/models/Message.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/ListExtension.dart';

class RoomShelf extends StatelessWidget {
  List<Widget> buildSugestions(BuildContext context) {
    var chatInfoProvider = Provider.of<ChatInfoProvider>(context);
    var message = chatInfoProvider.messages.last;

    if (message.aiResponse == null) {
      return [];
    }

    var params = message.aiResponse.suggestions;
    return params
        .map(
          (suggestion) => GestureDetector(
            child: Chip(
              shape: StadiumBorder(
                  side: BorderSide(color: Colors.amber[300], width: 2)),
              elevation: 0,
              label: Text(
                suggestion['title'],
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.amber[200],
            ),
            onTap: () {
              chatInfoProvider.addMessage(
                  message:
                      Message(body: suggestion['title'], sender: Sender.user));
              Provider.of<DialogflowProvider>(context, listen: false)
                  .response(suggestion['title'])
                  .then((response) => chatInfoProvider.addMessage(
                      message: Message(
                          body: response.getMessage(),
                          sender: Sender.bot,
                          aiResponse: response)));
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(0.1),
      // color: Colors.transparent,
      child: Consumer<ChatInfoProvider>(
        builder: (BuildContext context, ChatInfoProvider chatInfoProvider,
            Widget child) {
          var isUser =
              chatInfoProvider.messages.last?.sender == Sender.user ?? true;
          var suggestionAvailable = chatInfoProvider
                  .messages.last?.aiResponse?.suggestions?.isNotEmpty ??
              false;
          return Container(
            child: AnimatedContainer(
              height: chatInfoProvider.favoriteShelfOpen && suggestionAvailable
                  ? 50
                  : 0,
              width: MediaQuery.of(context).size.width,
              duration: Duration(
                  milliseconds:
                      WidgetsBinding.instance.disableAnimations ? 0 : 150),
              child: !isUser ? child : SizedBox(),
            ),
          );
        },
        child: Center(
          child: Container(
            child: ListView(
              reverse: false,
              padding: EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: buildSugestions(context).insertEveryNth(
                SizedBox(
                  width: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
