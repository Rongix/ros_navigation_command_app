import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/providers/AppStateProvider.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/screens/SettingsPageNew.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'ChatPage.dart';
import 'ControllerPage.dart';
import 'MapPage.dart';

class MainPage extends StatelessWidget {
  var appPages = [ChatPage(), ControllerPage(), MapPage()];

  @override
  Widget build(BuildContext context) {
    var appPagesNames = [
      S?.of(context)?.pageChatTitle ?? "",
      S?.of(context)?.pageControllerTitle ?? "",
      S?.of(context)?.pageMapTitle ?? ""
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).canvasColor,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark),
      child: Scaffold(
          extendBody: false,
          appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0), child: ShadowLine()),
              toolbarHeight: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 50
                  : 40,
              title: Consumer<AppStateProvider>(
                builder: (context, myType, child) => Text(
                    appPagesNames[
                        Provider.of<AppStateProvider>(context).activePageIndex],
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white)),
              ),
              actions: [
                //IconButtonsForAlternativeNavigation
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? _NavigationIconsRow()
                    : SizedBox(),

                IconButton(
                  tooltip: S?.of(context)?.tooltipRefreshConnection ?? "",
                  icon: Icon(MdiIcons.refresh,
                      // size: 30,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white),
                  onPressed: () {
                    Provider.of<RosProvider>(context, listen: false)
                        .subscribeRosAllTopics(context);
                  },
                ),

                IconButton(
                  tooltip: S?.of(context)?.tooltipStopActions ?? "",
                  icon: Icon(MdiIcons.stop,
                      // size: 30,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white),
                  onPressed: () {
                    Provider.of<RosProvider>(context, listen: false)
                        .unsubscribeRosAllTopics(context);
                  },
                ),

                IconButton(
                    tooltip: S?.of(context)?.tooltipSettings ?? "",
                    icon: Icon(MdiIcons.cog,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPageNew()));
                    }),
              ]),
          // bottomNavigationBar: Consumer2<AppStateProvider, SettingsProvider>(
          //     builder: (BuildContext context, appStateProvider,
          //             settingsProvider, Widget child) =>
          //         CustomNavigationBar(
          //           background: Theme.of(context).canvasColor,
          //           buttons: [
          //             CustomNavigationBarIcon(
          //               icon: Icon(Icons.chat_sharp),
          //               label: 'Czat',
          //               onPressed: () {
          //                 appStateProvider.setActivePage(0);
          //               },
          //               showLabel: false,
          //               selectedColo:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black54
          //                       : Colors.white,
          //               unselectedColor:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black12
          //                       : Colors.white24,
          //               index: 0,
          //               pageIndex: appStateProvider.activePageIndex,
          //             ),
          //             CustomNavigationBarIcon(
          //               icon: Icon(MdiIcons.gamepadUp),
          //               label: 'Sterowanie',
          //               onPressed: () {
          //                 appStateProvider.setActivePage(1);
          //               },
          //               showLabel: true,
          //               selectedColo:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black54
          //                       : Colors.white,
          //               unselectedColor:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black12
          //                       : Colors.white24,
          //               index: 1,
          //               pageIndex: appStateProvider.activePageIndex,
          //             ),
          //             CustomNavigationBarIcon(
          //               icon: Icon(MdiIcons.earthBox),
          //               label: 'Mapa',
          //               onPressed: () {
          //                 appStateProvider.setActivePage(2);
          //               },
          //               showLabel: false,
          //               selectedColo:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black54
          //                       : Colors.white,
          //               unselectedColor:
          //                   Theme.of(context).brightness == Brightness.light
          //                       ? Colors.black12
          //                       : Colors.white24,
          //               index: 2,
          //               pageIndex: appStateProvider.activePageIndex,
          //             ),
          //           ],
          //         )),

          //MATERIAL BOTTOM NAVIGATION BAR
          bottomNavigationBar: MediaQuery.of(context).orientation ==
                  Orientation.portrait
              ? Consumer2<AppStateProvider, SettingsProvider>(
                  builder: (BuildContext context, appStateProvider,
                          settingsProvider, Widget child) =>
                      BottomNavigationBar(
                          currentIndex: appStateProvider.activePageIndex,
                          backgroundColor: Theme.of(context).canvasColor,
                          showSelectedLabels:
                              settingsProvider.showNavigationBarLabels ?? false,
                          showUnselectedLabels:
                              settingsProvider.showNavigationBarLabels ?? false,
                          unselectedFontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize,
                          selectedFontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize,
                          elevation: 0,
                          unselectedItemColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black12
                                  : Colors.white24,
                          selectedItemColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.white,
                          items: [
                            BottomNavigationBarItem(
                              label: S?.of(context)?.pageChatTitle ?? "",
                              icon: Icon(Icons.chat_sharp),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(MdiIcons.gamepadUp),
                              label: S?.of(context)?.pageControllerTitle ?? "",
                            ),
                            BottomNavigationBarItem(
                              // icon: Icon(MdiIcons.mapMarkerDistance), title: Text("Mapa")),
                              icon: Icon(MdiIcons.earthBox),
                              label: S?.of(context)?.pageMapTitle ?? "",
                            ),
                          ],
                          onTap: (index) {
                            appStateProvider.setActivePage(index);
                            // Navigation with PagedView
                            // Provider.of<AppStateProvider>(context, listen: false)
                            //     .navigationBarPageController
                            //     .animateTo(index.toDouble(),
                            //         duration: Duration(milliseconds: 200), curve: Curves.linear);
                          }))
              : SizedBox(),
          body: Consumer<AppStateProvider>(
              builder: (context, provider, child) => appPages[provider.activePageIndex])),
    );
  }
}

class _CustomNavigationBar extends StatelessWidget {
  final Color background;
  final List<Widget> buttons;
  const _CustomNavigationBar(
      {Key key, @required this.background, @required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}

class _CustomNavigationBarIcon extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  final String label;
  final bool showLabel;
  final Color selectedColo;
  final Color unselectedColor;
  final int index;
  final int pageIndex;

  const _CustomNavigationBarIcon(
      {Key key,
      @required this.onPressed,
      @required this.icon,
      @required this.label,
      @required this.showLabel,
      @required this.selectedColo,
      @required this.unselectedColor,
      @required this.index,
      @required this.pageIndex})
      : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              tooltip: label,
              icon: icon,
              color: index == pageIndex ? selectedColo : unselectedColor,
              onPressed: onPressed),
        ],
      ),
    );
  }
}

//Used for landscape navigation mode
class _NavigationIconsRow extends StatelessWidget {
  const _NavigationIconsRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: "Czat",
          icon: Icon(Icons.chat_sharp,
              // size: 30,
              color: Provider.of<AppStateProvider>(context, listen: true)
                          .activePageIndex ==
                      0
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.white24),
          onPressed: () {
            Provider.of<AppStateProvider>(context, listen: false)
                .setActivePage(0);
          },
        ),
        VerticalDivider(),
        IconButton(
          tooltip: "Sterowanie",
          icon: Icon(MdiIcons.gamepadUp,
              // size: 30,
              color: Provider.of<AppStateProvider>(context, listen: true)
                          .activePageIndex ==
                      1
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.white24),
          onPressed: () {
            Provider.of<AppStateProvider>(context, listen: false)
                .setActivePage(1);
          },
        ),
        VerticalDivider(),
        IconButton(
          tooltip: "Mapa",
          icon: Icon(MdiIcons.earthBox,
              // size: 30,
              color: Provider.of<AppStateProvider>(context, listen: true)
                          .activePageIndex ==
                      2
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.white24),
          onPressed: () {
            Provider.of<AppStateProvider>(context, listen: false)
                .setActivePage(2);
          },
        ),
        VerticalDivider(
          width: 0,
        ),
      ],
    );
  }
}
