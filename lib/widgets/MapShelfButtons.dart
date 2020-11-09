import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapShelfButtons extends StatelessWidget {
  const MapShelfButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(children: [
      Consumer2<SettingsProvider, RosProvider>(
          builder: (context, settingsProvider, rosProvider, child) =>
              FloatingActionButton(
                  tooltip: 'Pokaż/ukryj siatkę',
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                  elevation: Provider.of<RosProvider>(context).mapImageAvailable
                      ? null
                      : 0,
                  mini: true,
                  child: Icon(
                      settingsProvider.showMapGrid
                          ? Icons.grid_on
                          : Icons.grid_off,
                      color: Provider.of<RosProvider>(context).mapImageAvailable
                          ? Theme.of(context).brightness == Brightness.light
                              ? Colors.black45
                              : Colors.white
                          : Theme.of(context).brightness == Brightness.light
                              ? Colors.black12
                              : Colors.white24),
                  onPressed: () {
                    if (rosProvider.mapImageAvailable)
                      settingsProvider.toggleMapGrid();
                  }))
    ]));
  }
}
