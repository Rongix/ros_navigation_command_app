import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/Message.dart';
import 'package:chatapp/providers/AudioProvider.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ChatBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black45
        : Colors.white;
    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Consumer2<ChatInfoProvider, AudioProvider>(
          builder: (context, chatInfoProvider, audioProvider, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      child: TextField(
                        // minLines: 1,
                        maxLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        controller: chatInfoProvider.chatTextController,
                        // textInputAction: TextInputAction.send,
                        // onSubmitted: (submit) {
                        //   sendTextMessage(context);
                        // },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 85, right: 95, top: 17, bottom: 0),
                          filled: true,
                          hintText: audioProvider.isRecording
                              ? "Nagrywam..."
                              : "Polecenie",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              color: Colors.grey,
                              width: 0.1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              color: Colors.grey,
                              width: 0.1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              color: Colors.grey,
                              width: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Tooltip(
                            message: "Typ wprowadzania polecenia (tekst)",
                            child: audioProvider.isRecording
                                ? IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(MdiIcons.waveform),
                                    color: Colors.red,
                                    onPressed: () {},
                                  )
                                : IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(Icons.short_text),
                                    color: iconColor,
                                    onPressed: () {},
                                  ),
                          ),
                          Tooltip(
                            message: "Szybkie odpowiedzi",
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: chatInfoProvider.favoriteShelfOpen
                                  ? Icon(Icons.star)
                                  : Icon(Icons.star_border),
                              onPressed: () {
                                chatInfoProvider.toggleFavoriteShelf();
                              },
                              color: audioProvider.isRecording
                                  ? Colors.red
                                  : iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AnimatedSwitcher(
                            child: chatInfoProvider.isControllerEmpty
                                ? SizedBox(
                                    width: 0,
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                    ),
                                    color: iconColor,
                                    onPressed: () {
                                      chatInfoProvider.clearController();
                                    },
                                  ),
                            duration: Duration(
                                milliseconds:
                                    WidgetsBinding.instance.disableAnimations
                                        ? 0
                                        : 200),
                          ),
                          // MicButton
                          AnimatedSwitcher(
                            child: chatInfoProvider.isControllerEmpty
                                ? Consumer<AudioProvider>(
                                    builder: (BuildContext context,
                                        AudioProvider audioProvider,
                                        Widget child) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          print(
                                              "looooooong -> record -> start");
                                          audioProvider.start();
                                        },
                                        onLongPressUp: () async {
                                          print("looong up -> record -> stop");
                                          var response =
                                              await audioProvider.stop();
                                          var content =
                                              await File(response.path)
                                                  .readAsBytes();

                                          // print(content);

                                          chatInfoProvider.addMessage(
                                              message: Message(
                                                  body:
                                                      "Wiadomość głosowa bez transkrypcji",
                                                  sender: Sender.user,
                                                  voiceActing: response));

                                          // final Soundpool pool = Soundpool();
                                          // pool.release();
                                          // final soundId =
                                          //     await pool.loadUint8List(content);

                                          // pool.play(soundId);

                                          var aiResponse = await Provider.of<
                                                      DialogflowProvider>(
                                                  context,
                                                  listen: false)
                                              .response(base64.encode(content),
                                                  isAudio: true);

                                          chatInfoProvider.addMessage(
                                              message: Message(
                                                  body: aiResponse.getMessage(),
                                                  sender: Sender.bot,
                                                  aiResponse: aiResponse));
                                          chatInfoProvider
                                              .updateLastVoiceMessageDescription(
                                                  aiResponse
                                                      .queryResult.queryText);

                                          //Supply response to matching Intent (to get action done)
                                          Provider.of<RosProvider>(context,
                                                  listen: false)
                                              .matchIntent(aiResponse, context);
                                        },
                                        child: IconButton(
                                            icon: Icon(Icons.mic),
                                            onPressed: () {
                                              print('Przytrzymaj zeby nagrac');
                                            },
                                            color: audioProvider.isRecording
                                                ? Colors.red
                                                : iconColor),
                                      );
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      sendTextMessage(context);
                                    },
                                    color: iconColor),
                            duration: Duration(
                                milliseconds:
                                    WidgetsBinding.instance.disableAnimations
                                        ? 0
                                        : 100),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2),
              //Mic button as circle
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withAlpha(10)
                      : Colors.white.withAlpha(30),
                ),
              ),
              //SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}

void sendTextMessage(BuildContext context) {
  HapticFeedback.vibrate();
  var chatInfoProvider = Provider.of<ChatInfoProvider>(context, listen: false);
  var userMessage = chatInfoProvider.chatTextController.text;

  Provider.of<ChatInfoProvider>(context, listen: false)
      .addMessage(message: Message(body: userMessage, sender: Sender.user));

  pushAiResponse(context, userMessage);
}

// void sendVoiceMessage(BuildContext context) {}

void pushAiResponse(BuildContext context, String query) {
  Provider.of<DialogflowProvider>(context, listen: false)
      .response(query)
      .then((response) {
    Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
        message: Message(
            body: response.getMessage(),
            sender: Sender.bot,
            aiResponse: response));

    //Supply response to matching Intent (to get action done)
    Provider.of<RosProvider>(context, listen: false)
        .matchIntent(response, context);
  });
  //Supply response to matching Intent (to get action done)
}
