import 'package:chatapp/models/Message.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/ListExtension.dart';

class FavoriteShelf extends StatelessWidget {
  List<Widget> buildSugestions(BuildContext context) {
    var chatInfoProvider = Provider.of<ChatInfoProvider>(context);
    var message = chatInfoProvider.messages.last;
    Color textColor = Theme.of(context).accentColor.computeLuminance() > 0.4
        ? Colors.black.withOpacity(0.6)
        : Colors.white;

    var textTheme = Theme.of(context)
        .textTheme
        .subtitle1
        .merge(TextStyle(color: textColor));

    if (message.aiResponse == null) {
      return [];
    }

    var params = message.aiResponse.suggestions;
    return params
        .map(
          (suggestion) => GestureDetector(
            child: Chip(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              label: Text(
                suggestion['title'],
                style: textTheme,
              ),
              backgroundColor: Theme.of(context).accentColor,
            ),
            onTap: () {
              chatInfoProvider.addMessage(
                  message:
                      Message(body: suggestion['title'], sender: Sender.user));
              Provider.of<DialogflowProvider>(context, listen: false)
                  .response(suggestion['title'])
                  .then((response) {
                chatInfoProvider.addMessage(
                    message: Message(
                        body: response.getMessage(),
                        sender: Sender.bot,
                        aiResponse: response));

                //Supply response to matching Intent (to get action done)
                Provider.of<RosProvider>(context, listen: false)
                    .matchIntent(response, context);
              });
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      // color: Colors.transparent,
      child: Consumer2<ChatInfoProvider, SettingsProvider>(
        builder: (context, chatInfoProvider, settingsProvider, child) {
          var isUser =
              (chatInfoProvider.messages.last?.sender == Sender.user) ?? true;
          var suggestionAvailable = chatInfoProvider
                  .messages.last?.aiResponse?.suggestions?.isNotEmpty ??
              false;
          return Container(
            child: AnimatedContainer(
              height: chatInfoProvider.favoriteShelfOpen && suggestionAvailable
                  ? 40
                  : 0,
              width: MediaQuery.of(context).size.width,
              duration: Duration(
                  milliseconds:
                      WidgetsBinding.instance.disableAnimations ? 0 : 150),
              child: !isUser
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: ListView(
                        physics: settingsProvider.limitAnimations ?? false
                            ? null
                            : BouncingScrollPhysics(),
                        reverse: false,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: false,
                        children: buildSugestions(context).insertEveryNth(
                          SizedBox(width: 5),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
