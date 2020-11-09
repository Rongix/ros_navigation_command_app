import 'package:chatapp/widgets/ChatBar.dart';
import 'package:chatapp/widgets/FavoriteShelf.dart';
import 'package:chatapp/widgets/MessagesList.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Messageslist(),
          // Divider(
          //   height: 0,
          //   thickness: 0.5,
          // ),
          ShadowLine(),
          FavoriteShelf(),
          ChatBar(),
        ],
      ),
    );
  }
}
