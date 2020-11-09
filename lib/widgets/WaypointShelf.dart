import 'package:chatapp/models/Waypoint.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/StringExtension.dart';

import 'WaypointDialog.dart';

enum WaypointShelfEditOptions { edit, delete, cancel }

class WaypointShelf extends StatelessWidget {
  List<Widget> buildWaypoints(BuildContext context, WaypointList waypoints) {
    if (waypoints == null) {
      return [];
    }

    return waypoints.waypoints
        .map((waypoint) =>
            Consumer<RosProvider>(builder: (context, rosProvider, child) {
              bool isActive = rosProvider.activeWaypoint == waypoint;
              Color waypointColor = waypoint.color;
              // Color backgroundColor = isActive
              //     ? Theme.of(context).accentColor
              //     : Theme.of(context).chipTheme.backgroundColor;
              Color backgroundColor =
                  Theme.of(context).chipTheme.backgroundColor;
              Color textColor = backgroundColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white;
              // Color avatarBackgroundColor =
              //     waypoint.color.computeLuminance() > 0.5
              //         ? Colors.black38
              //         : Colors.white30;
              return GestureDetector(
                child: Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Chip(
                        elevation: 0,
                        avatar: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            isActive
                                ? MdiIcons.rhombus
                                : MdiIcons.rhombusOutline,
                            color: isActive
                                ? waypointColor
                                : waypointColor.withOpacity(0.4),
                          ),
                        ),
                        shape: isActive
                            ? StadiumBorder(
                                side:
                                    BorderSide(color: waypointColor, width: 1))
                            : StadiumBorder(
                                side: BorderSide(
                                    color: Colors.transparent, width: 1)),
                        label: Text(waypoint.name.capitalize(),
                            style: TextStyle(color: textColor)),
                        backgroundColor:
                            isActive ? backgroundColor.withOpacity(0.8) : null,
                      ),
                    )),
                onTap: () {
                  rosProvider.setactiveWaypoint(waypoint, context);
                },
                onLongPress: () {
                  showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                                dense: true,
                                leading: Icon(
                                  MdiIcons.rhombus,
                                  color: waypoint.color,
                                ),
                                title: Text(
                                  '${waypoint.name.capitalize()}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )),
                            Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edytuj'),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => WaypointDialog(
                                          existingWaypoint: waypoint,
                                        )).then(
                                    (value) => Navigator.of(context).pop());
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Usuń'),
                              onTap: () {
                                Navigator.of(context).pop(
                                  Provider.of<SettingsProvider>(context,
                                          listen: false)
                                      .removeWaypoint(waypoint),
                                );
                              },
                            )
                          ],
                        );
                      });
                },
              );
            }))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Material(
          elevation: 0,
          child: Consumer2<ChatInfoProvider, SettingsProvider>(
              builder: (context, chatInfoProvider, settingsProvider, child) =>
                  ListView(
                      physics: settingsProvider.limitAnimations
                          ? null
                          : BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      children: buildWaypoints(
                          context, settingsProvider.waypoints)))),
    );
  }
}
