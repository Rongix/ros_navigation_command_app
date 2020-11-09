import 'package:audio_recorder/audio_recorder.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:flutter/widgets.dart';

enum Sender { user, system, bot }

class IconWithDescription {
  final Function onTap;
  final IconData icon;
  final String description;

  IconWithDescription({this.onTap, this.icon, this.description})
      : assert(onTap != null),
        assert(icon != null),
        assert(description != null);
}

class Message {
  final String heading;

  // If message has no heading or description, fill body only;
  String body;
  List<IconWithDescription> actions;

  final Sender sender;
  final DateTime timestamp;
  final CustomAIResponse aiResponse;
  final Recording voiceActing;

  Message({
    this.heading,
    this.body,
    this.actions,
    this.sender,
    DateTime timestamp,
    this.aiResponse,
    this.voiceActing,
  }) : this.timestamp = timestamp ?? DateTime.now();
}
