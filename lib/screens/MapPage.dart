import 'dart:ui' as ui;

import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/MapPainter.dart';
import 'package:chatapp/widgets/MapShelfButtons.dart';
import 'package:chatapp/widgets/RainbowCircularIndicator.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:chatapp/widgets/StatusInfo.dart';
import 'package:chatapp/widgets/WaypointDialog.dart';
import 'package:chatapp/widgets/WaypointShelf.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  ui.Image previousMap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          bottom: 45,
          left: 0,
          right: 0,
          top: 0,
          child: Provider.of<RosProvider>(context, listen: true)
                  .mapImageAvailable
              ? Container(
                  // color: Theme.of(context).canvasColor,
                  child: Consumer2<SettingsProvider, RosProvider>(
                      builder: (ctx, settingsProvider, rosProvider, child) {
                  assert(rosProvider.mapImage != null);
                  return InteractiveViewer(
                    maxScale: 10,
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: FutureBuilder(
                            future: rosProvider.getMapAsImage(
                                Theme.of(context).backgroundColor,
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.grey[300]),
                            initialData: previousMap,
                            builder: (_, img) {
                              if (img.data == null) {
                                return SizedBox();
                              }
                              previousMap = img.data;
                              return Map(
                                  map: img.data,
                                  showGrid: settingsProvider.showMapGrid);
                            }),
                      ),
                    ),
                  );
                }))
              : Consumer<SettingsProvider>(
                  builder: (ctx, settingsProvider, child) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Czekam na obraz mapy",
                                style: Theme.of(context).textTheme.subtitle1,
                                textAlign: TextAlign.center),
                            Text('${settingsProvider.topicMap}',
                                style: Theme.of(context).textTheme.caption,
                                textAlign: TextAlign.center),
                            SizedBox(height: 15),
                            RainbowCircularIndicator(),
                          ])),
        ),
        Positioned(child: StatusInfo()),
        Positioned(
          bottom: 52,
          left: 0,
          child: MapShelfButtons(),
        ),
        Positioned(bottom: 0, left: 0, right: 0, child: WaypointShelf()),
        Positioned(
          bottom: 45,
          right: 0,
          left: 0,
          child: ShadowLine(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 55, right: 10),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).chipTheme.backgroundColor,
                    heroTag: null,
                    tooltip: 'Utwórz nowy znacznik lokalizacyjny',
                    onPressed: () {
                      showDialog(
                          context: context, builder: (_) => WaypointDialog());
                    },
                    child: Icon(MdiIcons.plus,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black45
                            : Colors.white),
                    mini: false),
              ),
              // FloatingActionButton(
              //     heroTag: null,
              //     backgroundColor: Theme.of(context).chipTheme.backgroundColor,
              //     elevation: Provider.of<RosProvider>(context).mapImageAvailable
              //         ? null
              //         : 0,
              //     tooltip: 'Przejedź robotem do wybranego znacznika',
              //     onPressed: () {},
              //     child: Icon(Icons.directions,
              //         color: Provider.of<RosProvider>(context).mapImageAvailable
              //             ? Theme.of(context).brightness == Brightness.light
              //                 ? Colors.black45
              //                 : Colors.white
              //             : Theme.of(context).brightness == Brightness.light
              //                 ? Colors.black12
              //                 : Colors.white24),
              //     mini: false),
            ]),
          ),
        )
      ],
    );
  }
}
