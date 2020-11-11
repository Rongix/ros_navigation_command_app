// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(type) => "${Intl.select(type, {'title': 'Limit animations', 'desc': 'Changes how lists and messages animate', })}";

  static m1(type) => "${Intl.select(type, {'title': 'Button labels', 'desc': 'Show additional labels under buttons', })}";

  static m2(type) => "${Intl.select(type, {'title': 'App settings', 'desc': 'General settings & accessibility', })}";

  static m3(type) => "${Intl.select(type, {'title': 'Ros configuration', 'desc': 'Ros web config of main and current device', })}";

  static m4(theme) => "${Intl.select(theme, {'light': 'Light theme', 'dark': 'Dark theme', 'system': 'System theme', })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "creatorAddNew" : MessageLookupByLibrary.simpleMessage("Add new marker"),
    "creatorEdit" : MessageLookupByLibrary.simpleMessage("Edit marker"),
    "creatorHue" : MessageLookupByLibrary.simpleMessage("Hue"),
    "creatorName" : MessageLookupByLibrary.simpleMessage("Name"),
    "pageChatIntroAction1" : MessageLookupByLibrary.simpleMessage("Click text icon or order field"),
    "pageChatIntroAction2" : MessageLookupByLibrary.simpleMessage("Hold mic icon"),
    "pageChatIntroBody" : MessageLookupByLibrary.simpleMessage("Try to talk with voice assistant to issue commands. To begin:"),
    "pageChatIntroTitle" : MessageLookupByLibrary.simpleMessage("Hello"),
    "pageChatRecording" : MessageLookupByLibrary.simpleMessage("Recording"),
    "pageChatTexting" : MessageLookupByLibrary.simpleMessage("Order"),
    "pageChatTitle" : MessageLookupByLibrary.simpleMessage("Chat"),
    "pageControllerInfoTitle" : MessageLookupByLibrary.simpleMessage("Waiting for cammera topic"),
    "pageControllerTitle" : MessageLookupByLibrary.simpleMessage("Controller"),
    "pageMapButtonFloating" : MessageLookupByLibrary.simpleMessage("Add new map marker"),
    "pageMapButtonGrid" : MessageLookupByLibrary.simpleMessage("Show / hide grid"),
    "pageMapInfoTitle" : MessageLookupByLibrary.simpleMessage("Waiting for map topic"),
    "pageMapTitle" : MessageLookupByLibrary.simpleMessage("Map"),
    "pageSettingsAbout" : MessageLookupByLibrary.simpleMessage("About"),
    "pageSettingsAnimations" : m0,
    "pageSettingsButtonsDesc" : m1,
    "pageSettingsGeneral" : m2,
    "pageSettingsRos" : m3,
    "pageSettingsRosBattery" : MessageLookupByLibrary.simpleMessage("Battery"),
    "pageSettingsRosCamera" : MessageLookupByLibrary.simpleMessage("Camera"),
    "pageSettingsRosChatter" : MessageLookupByLibrary.simpleMessage("Chatter"),
    "pageSettingsRosDevice" : MessageLookupByLibrary.simpleMessage("This device (ip)"),
    "pageSettingsRosMain" : MessageLookupByLibrary.simpleMessage("Main server (ip)"),
    "pageSettingsRosMap" : MessageLookupByLibrary.simpleMessage("Map"),
    "pageSettingsRosNavigation" : MessageLookupByLibrary.simpleMessage("Navigation / Goal"),
    "pageSettingsRosOdom" : MessageLookupByLibrary.simpleMessage("Odometry"),
    "pageSettingsRosVelocity" : MessageLookupByLibrary.simpleMessage("Linear / angular velocity"),
    "pageSettingsThemes" : m4,
    "pageSettingsTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "tooltipChatMode" : MessageLookupByLibrary.simpleMessage("Text input"),
    "tooltipChatStar" : MessageLookupByLibrary.simpleMessage("Quick Replies"),
    "tooltipCoordinates" : MessageLookupByLibrary.simpleMessage("Coordinates"),
    "tooltipCurrentLocation" : MessageLookupByLibrary.simpleMessage("Current robot location"),
    "tooltipRandom" : MessageLookupByLibrary.simpleMessage("Random name"),
    "tooltipRefreshConnection" : MessageLookupByLibrary.simpleMessage("Refresh connection"),
    "tooltipSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "tooltipStopActions" : MessageLookupByLibrary.simpleMessage("Stop actions")
  };
}
