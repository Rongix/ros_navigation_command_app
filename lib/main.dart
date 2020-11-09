import 'dart:io';
import 'dart:async';

import 'package:chatapp/providers/AppStateProvider.dart';
import 'package:chatapp/providers/AudioProvider.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/screens/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ChangeNotifierProvider(create: (_) => ChatInfoProvider()),
    ChangeNotifierProvider(create: (_) => DialogflowProvider()),
    ChangeNotifierProvider(create: (_) => AudioProvider()),
    ChangeNotifierProvider(create: (_) => AppStateProvider()),
    ChangeNotifierProvider(create: (_) => RosProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future applicationLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicationLoaded = configureApplication(context);
  }

  Future configureApplication(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays(
    //     [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));

    //Get local storage initialized - for saved waypoints locations
    Provider.of<SettingsProvider>(context, listen: false)
        .localStorageInitialize();

    return Future.wait([
      //Get shared preferences intialized
      Provider.of<SettingsProvider>(context, listen: false).prefsInitialize(),
      getTemporaryDirectory().then((dir) async {
        dir = Directory(dir.path + '/recordings');
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
        await dir.create();
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: applicationLoaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return mainApp(context);
        } else {
          return loadingScreen(context);
        }
      },
    );
  }

  Widget loadingScreen(BuildContext context) {
    return MaterialApp(
      home: Container(),
    );
  }

  Widget mainApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice App',
      themeMode: Provider.of<SettingsProvider>(context, listen: true).appTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        // primaryColor: Colors.blueAccent[300],
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.blue[50],
        canvasColor: Color.fromRGBO(245, 245, 245, 1),
        appBarTheme: AppBarTheme(elevation: 0),
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),

        // accentColor: Colors.lightBlueAccent[400],
        accentColor: Colors.amber[200],
        textSelectionHandleColor: Colors.amber,

        scaffoldBackgroundColor: Colors.white,
        chipTheme: ThemeData.light()
            .chipTheme
            .copyWith(backgroundColor: Color.fromRGBO(230, 230, 230, 1)),
      ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primaryColor: Color.fromRGBO(60, 60, 60, 1),
      //   accentColor: Colors.cyan,
      //   scaffoldBackgroundColor: Color.fromRGBO(80, 80, 80, 1),
      //   textSelectionHandleColor: Colors.cyanAccent,
      // ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // primaryColor: Color.fromRGBO(60, 60, 60, 1),
        // scaffoldBackgroundColor: Color.fromRGBO(80, 80, 80, 1),
        // textSelectionHandleColor: Colors.cyanAccent,
        primaryColor: Color.fromRGBO(40, 40, 40, 1),
        canvasColor: Color.fromRGBO(60, 60, 60, 1),
        scaffoldBackgroundColor: Color.fromRGBO(40, 40, 40, 1),
        backgroundColor: Color.fromRGBO(50, 50, 50, 1),
        appBarTheme: AppBarTheme(elevation: 0),
        accentColor: Colors.cyan,
        textSelectionHandleColor: Colors.cyan,
        chipTheme: ThemeData.dark()
            .chipTheme
            .copyWith(backgroundColor: Color.fromRGBO(50, 50, 50, 1)),
      ),

      home: MainPage(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => ChatPage(),
      // },
    );
  }
}
