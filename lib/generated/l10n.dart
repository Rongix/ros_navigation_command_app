// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Stop actions`
  String get tooltipStopActions {
    return Intl.message(
      'Stop actions',
      name: 'tooltipStopActions',
      desc: '',
      args: [],
    );
  }

  /// `Refresh connection`
  String get tooltipRefreshConnection {
    return Intl.message(
      'Refresh connection',
      name: 'tooltipRefreshConnection',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get tooltipSettings {
    return Intl.message(
      'Settings',
      name: 'tooltipSettings',
      desc: '',
      args: [],
    );
  }

  /// `Text input`
  String get tooltipChatMode {
    return Intl.message(
      'Text input',
      name: 'tooltipChatMode',
      desc: '',
      args: [],
    );
  }

  /// `Quick Replies`
  String get tooltipChatStar {
    return Intl.message(
      'Quick Replies',
      name: 'tooltipChatStar',
      desc: '',
      args: [],
    );
  }

  /// `Random name`
  String get tooltipRandom {
    return Intl.message(
      'Random name',
      name: 'tooltipRandom',
      desc: '',
      args: [],
    );
  }

  /// `Current robot location`
  String get tooltipCurrentLocation {
    return Intl.message(
      'Current robot location',
      name: 'tooltipCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Coordinates`
  String get tooltipCoordinates {
    return Intl.message(
      'Coordinates',
      name: 'tooltipCoordinates',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get pageChatTitle {
    return Intl.message(
      'Chat',
      name: 'pageChatTitle',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get pageChatTexting {
    return Intl.message(
      'Order',
      name: 'pageChatTexting',
      desc: '',
      args: [],
    );
  }

  /// `Recording`
  String get pageChatRecording {
    return Intl.message(
      'Recording',
      name: 'pageChatRecording',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get pageChatIntroTitle {
    return Intl.message(
      'Hello',
      name: 'pageChatIntroTitle',
      desc: '',
      args: [],
    );
  }

  /// `Try to talk with voice assistant to issue commands. To begin:`
  String get pageChatIntroBody {
    return Intl.message(
      'Try to talk with voice assistant to issue commands. To begin:',
      name: 'pageChatIntroBody',
      desc: '',
      args: [],
    );
  }

  /// `Click text icon or order field`
  String get pageChatIntroAction1 {
    return Intl.message(
      'Click text icon or order field',
      name: 'pageChatIntroAction1',
      desc: '',
      args: [],
    );
  }

  /// `Hold mic icon`
  String get pageChatIntroAction2 {
    return Intl.message(
      'Hold mic icon',
      name: 'pageChatIntroAction2',
      desc: '',
      args: [],
    );
  }

  /// `Controller`
  String get pageControllerTitle {
    return Intl.message(
      'Controller',
      name: 'pageControllerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for cammera topic`
  String get pageControllerInfoTitle {
    return Intl.message(
      'Waiting for cammera topic',
      name: 'pageControllerInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get pageMapTitle {
    return Intl.message(
      'Map',
      name: 'pageMapTitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for map topic`
  String get pageMapInfoTitle {
    return Intl.message(
      'Waiting for map topic',
      name: 'pageMapInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show / hide grid`
  String get pageMapButtonGrid {
    return Intl.message(
      'Show / hide grid',
      name: 'pageMapButtonGrid',
      desc: '',
      args: [],
    );
  }

  /// `Add new map marker`
  String get pageMapButtonFloating {
    return Intl.message(
      'Add new map marker',
      name: 'pageMapButtonFloating',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'pageMapInitialRooms' key

  /// `Settings`
  String get pageSettingsTitle {
    return Intl.message(
      'Settings',
      name: 'pageSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `{type, select, title {App settings} desc {General settings & accessibility}}`
  String pageSettingsGeneral(Object type) {
    return Intl.select(
      type,
      {
        'title': 'App settings',
        'desc': 'General settings & accessibility',
      },
      name: 'pageSettingsGeneral',
      desc: '',
      args: [type],
    );
  }

  /// `{theme, select, light {Light theme} dark {Dark theme} system {System theme}}`
  String pageSettingsThemes(Object theme) {
    return Intl.select(
      theme,
      {
        'light': 'Light theme',
        'dark': 'Dark theme',
        'system': 'System theme',
      },
      name: 'pageSettingsThemes',
      desc: '',
      args: [theme],
    );
  }

  /// `{type, select, title {Limit animations} desc {Changes how lists and messages animate}}`
  String pageSettingsAnimations(Object type) {
    return Intl.select(
      type,
      {
        'title': 'Limit animations',
        'desc': 'Changes how lists and messages animate',
      },
      name: 'pageSettingsAnimations',
      desc: '',
      args: [type],
    );
  }

  /// `{type, select, title {Button labels} desc {Show additional labels under buttons}}`
  String pageSettingsButtonsDesc(Object type) {
    return Intl.select(
      type,
      {
        'title': 'Button labels',
        'desc': 'Show additional labels under buttons',
      },
      name: 'pageSettingsButtonsDesc',
      desc: '',
      args: [type],
    );
  }

  /// `{type, select, title {Ros configuration} desc {Ros web config of main and current device}}`
  String pageSettingsRos(Object type) {
    return Intl.select(
      type,
      {
        'title': 'Ros configuration',
        'desc': 'Ros web config of main and current device',
      },
      name: 'pageSettingsRos',
      desc: '',
      args: [type],
    );
  }

  /// `Main server (ip)`
  String get pageSettingsRosMain {
    return Intl.message(
      'Main server (ip)',
      name: 'pageSettingsRosMain',
      desc: '',
      args: [],
    );
  }

  /// `This device (ip)`
  String get pageSettingsRosDevice {
    return Intl.message(
      'This device (ip)',
      name: 'pageSettingsRosDevice',
      desc: '',
      args: [],
    );
  }

  /// `Odometry`
  String get pageSettingsRosOdom {
    return Intl.message(
      'Odometry',
      name: 'pageSettingsRosOdom',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get pageSettingsRosCamera {
    return Intl.message(
      'Camera',
      name: 'pageSettingsRosCamera',
      desc: '',
      args: [],
    );
  }

  /// `Battery`
  String get pageSettingsRosBattery {
    return Intl.message(
      'Battery',
      name: 'pageSettingsRosBattery',
      desc: '',
      args: [],
    );
  }

  /// `Linear / angular velocity`
  String get pageSettingsRosVelocity {
    return Intl.message(
      'Linear / angular velocity',
      name: 'pageSettingsRosVelocity',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get pageSettingsRosMap {
    return Intl.message(
      'Map',
      name: 'pageSettingsRosMap',
      desc: '',
      args: [],
    );
  }

  /// `Navigation / Goal`
  String get pageSettingsRosNavigation {
    return Intl.message(
      'Navigation / Goal',
      name: 'pageSettingsRosNavigation',
      desc: '',
      args: [],
    );
  }

  /// `Chatter`
  String get pageSettingsRosChatter {
    return Intl.message(
      'Chatter',
      name: 'pageSettingsRosChatter',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get pageSettingsAbout {
    return Intl.message(
      'About',
      name: 'pageSettingsAbout',
      desc: '',
      args: [],
    );
  }

  /// `Add new marker`
  String get creatorAddNew {
    return Intl.message(
      'Add new marker',
      name: 'creatorAddNew',
      desc: '',
      args: [],
    );
  }

  /// `Edit marker`
  String get creatorEdit {
    return Intl.message(
      'Edit marker',
      name: 'creatorEdit',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get creatorName {
    return Intl.message(
      'Name',
      name: 'creatorName',
      desc: '',
      args: [],
    );
  }

  /// `Hue`
  String get creatorHue {
    return Intl.message(
      'Hue',
      name: 'creatorHue',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}