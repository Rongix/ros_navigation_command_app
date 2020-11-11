import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatInfoProvider extends ChangeNotifier {
  //favorite shelf
  var _favoriteShelfOpen = true;
  void toggleFavoriteShelf() {
    _favoriteShelfOpen = !_favoriteShelfOpen;
    notifyListeners();
  }

  var _listKey = GlobalKey<AnimatedListState>();
  List<Message> _messages = [
    Message(
        heading: "Hello",
        body:
            'Voice and chat commands are disabled by default in this app version. You can issue commands in controller and map pages. Your actions will show below',
        sender: Sender.system,
        actions: [
          // IconWithDescription(
          //     onTap: () {
          //       print('aaa');
          //     },
          //     icon: MdiIcons.textShort,
          //     description:
          //         'Naciśnij ikonę tekstu lub kliknij pole "Polecenie"'),
          // IconWithDescription(
          //     onTap: () {
          //       print('aaa');
          //     },
          //     icon: Icons.mic,
          //     description:
          //         'Trzymaj ikonę mikrofonu aby nagrać wiadomość głosową'),
        ])
  ];

  var _controller = TextEditingController();
  var _isControllerEmpty = true;

  ChatInfoProvider() : super() {
    _controller.addListener(_textUpdate);
  }

  void clearController() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.clear();
    });
  }

  void _textUpdate() {
    if (_isControllerEmpty != _controller.text.isEmpty) {
      _isControllerEmpty = _controller.text.isEmpty;
      notifyListeners();
    }
  }

  void addMessage({@required Message message}) {
    if (_listKey.currentWidget != null) {
      print("Animowanie");
      _listKey.currentState.insertItem(_messages.length,
          duration: const Duration(milliseconds: 150));
      clearController();
    }
    _messages.add(message);
    notifyListeners();
  }

  // Works as speech to text from dialogflow
  void updateLastVoiceMessageDescription(String description) {
    if (_messages[_messages.length - 2].body ==
        "Wiadomość głosowa bez transkrypcji") {
      _messages[_messages.length - 2].body = description;
      notifyListeners();
    }
  }

  bool get favoriteShelfOpen => _favoriteShelfOpen;
  bool get isControllerEmpty => _isControllerEmpty;
  TextEditingController get chatTextController => _controller;
  GlobalKey<AnimatedListState> get listKey => _listKey;
  List<Message> get messages => _messages;
}
