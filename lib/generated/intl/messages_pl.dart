// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  static m0(type) => "${Intl.select(type, {'title': 'Ogranicz animacje', 'desc': 'Zmienia zachowanie list, wiadomości', })}";

  static m1(type) => "${Intl.select(type, {'title': 'Podpisy przycisków', 'desc': 'Dodaje podpisy pod przyciskami nawigacji', })}";

  static m2(type) => "${Intl.select(type, {'title': 'Ustawienia aplikacji', 'desc': 'Ogólne ustawienia i opcje dostępu', })}";

  static m3(type) => "${Intl.select(type, {'title': 'Konfiguracja ROS', 'desc': 'Konfiguracja sieciowa ROS, należy wprowadzić adres urządzenia roscore i adres ip aktualnego urządzenia', })}";

  static m4(theme) => "${Intl.select(theme, {'light': 'Jasny motyw', 'dark': 'Ciemny motyw', 'system': 'Systemowy motyw', })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "creatorAddNew" : MessageLookupByLibrary.simpleMessage("Dodaj nowy znacznik"),
    "creatorEdit" : MessageLookupByLibrary.simpleMessage("Edytuj znacznik"),
    "creatorHue" : MessageLookupByLibrary.simpleMessage("Barwa"),
    "creatorName" : MessageLookupByLibrary.simpleMessage("Nazwa"),
    "pageChatIntroAction1" : MessageLookupByLibrary.simpleMessage("Click text icon or order field"),
    "pageChatIntroAction2" : MessageLookupByLibrary.simpleMessage("Hold mic icon"),
    "pageChatIntroBody" : MessageLookupByLibrary.simpleMessage("Try to talk with voice assistant to issue commands. To begin:"),
    "pageChatIntroTitle" : MessageLookupByLibrary.simpleMessage("Hello"),
    "pageChatRecording" : MessageLookupByLibrary.simpleMessage("Nagrywam..."),
    "pageChatTexting" : MessageLookupByLibrary.simpleMessage("Polecenie"),
    "pageChatTitle" : MessageLookupByLibrary.simpleMessage("Chat"),
    "pageControllerInfoTitle" : MessageLookupByLibrary.simpleMessage("Czekam na obraz z kamery"),
    "pageControllerTitle" : MessageLookupByLibrary.simpleMessage("Controller"),
    "pageMapButtonFloating" : MessageLookupByLibrary.simpleMessage("Utwórz nowy znacznik lokalizacyjny"),
    "pageMapButtonGrid" : MessageLookupByLibrary.simpleMessage("Pokaż / ukryj siatkę"),
    "pageMapInfoTitle" : MessageLookupByLibrary.simpleMessage("Czekam na obraz mapy"),
    "pageMapTitle" : MessageLookupByLibrary.simpleMessage("Mapa"),
    "pageSettingsAbout" : MessageLookupByLibrary.simpleMessage("O aplikacji"),
    "pageSettingsAnimations" : m0,
    "pageSettingsButtonsDesc" : m1,
    "pageSettingsGeneral" : m2,
    "pageSettingsRos" : m3,
    "pageSettingsRosBattery" : MessageLookupByLibrary.simpleMessage("Bateria"),
    "pageSettingsRosCamera" : MessageLookupByLibrary.simpleMessage("Kamera"),
    "pageSettingsRosChatter" : MessageLookupByLibrary.simpleMessage("Chatter"),
    "pageSettingsRosDevice" : MessageLookupByLibrary.simpleMessage("To urządzenie (ip)"),
    "pageSettingsRosMain" : MessageLookupByLibrary.simpleMessage("Główny serwer (ip)"),
    "pageSettingsRosMap" : MessageLookupByLibrary.simpleMessage("Mapa"),
    "pageSettingsRosNavigation" : MessageLookupByLibrary.simpleMessage("Nawigacja / Cel"),
    "pageSettingsRosOdom" : MessageLookupByLibrary.simpleMessage("Odometria robota"),
    "pageSettingsRosVelocity" : MessageLookupByLibrary.simpleMessage("Prędkość liniowa / kątowa silników"),
    "pageSettingsThemes" : m4,
    "pageSettingsTitle" : MessageLookupByLibrary.simpleMessage("Ustawienia"),
    "tooltipChatMode" : MessageLookupByLibrary.simpleMessage("Polecenie tekstowe"),
    "tooltipChatStar" : MessageLookupByLibrary.simpleMessage("Szybkie odpowiedzi"),
    "tooltipCoordinates" : MessageLookupByLibrary.simpleMessage("Ręczne koordynaty"),
    "tooltipCurrentLocation" : MessageLookupByLibrary.simpleMessage("Aktualne położenie robota"),
    "tooltipRandom" : MessageLookupByLibrary.simpleMessage("Wylosuj nazwę"),
    "tooltipRefreshConnection" : MessageLookupByLibrary.simpleMessage("Odśwież połączenie"),
    "tooltipSettings" : MessageLookupByLibrary.simpleMessage("Ustawienia"),
    "tooltipStopActions" : MessageLookupByLibrary.simpleMessage("Zatrzymaj akcje robota")
  };
}
