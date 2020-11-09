import 'dart:math';

import 'package:chatapp/models/Waypoint.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/ColorPickerCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart' as wp;

String _randomName() {
  return '${wp.generateWordPairs().take(1).reduce((value, element) => null).asPascalCase}';
}

class WaypointDialog extends StatefulWidget {
  const WaypointDialog({Key key, this.existingWaypoint}) : super(key: key);

  final Waypoint existingWaypoint;

  @override
  _WaypointDialogState createState() => _WaypointDialogState();
}

class _WaypointDialogState extends State<WaypointDialog> {
  // List<bool> _selections = List.generate(3, (_) => false);

  List<bool> _selections = [false, false];
  var _nameController = TextEditingController();
  var _xController = TextEditingController();
  var _yController = TextEditingController();

  var _scrollController = ScrollController();
  Color _waypointColor;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.existingWaypoint?.name ?? _randomName();
    _xController.text = widget.existingWaypoint?.x.toString() ?? '0';
    _yController.text = widget.existingWaypoint?.y.toString() ?? '0';
    _waypointColor = widget.existingWaypoint?.color ??
        HSVColor.fromAHSV(1, Random().nextDouble() * 360, 1, 1).toColor();

    if (widget.existingWaypoint != null) {
      _isEditMode = true;
      _selections[1] = true;
    } else {
      _selections[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black.withOpacity(0.6)
        : Colors.white;

    if (_selections[0] &&
        Provider.of<RosProvider>(context, listen: false).mapImageAvailable) {
      _xController.text = Provider.of<RosProvider>(context, listen: false)
          .odometry
          .pose
          .pose
          .position
          .x
          .toStringAsFixed(2);
      _yController.text = Provider.of<RosProvider>(context, listen: false)
          .odometry
          .pose
          .pose
          .position
          .y
          .toStringAsFixed(2);
    }

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      actionsPadding: EdgeInsets.only(right: 10),
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.fromLTRB(29, 24, 24, 10),
      title: Row(
        children: [
          Theme(
              data: Theme.of(context)
                  .copyWith(iconTheme: IconThemeData(color: textColor)),
              child: Icon(_isEditMode ? Icons.create : Icons.add)),
          SizedBox(width: 8),
          _isEditMode
              ? Text('Edytuj znacznik', style: TextStyle(color: textColor))
              : Text('Dodaj nowy znacznik', style: TextStyle(color: textColor)),
        ],
      ),
      content: Theme(
        data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).accentColor
                : null),
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Scrollbar(
              child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  physics: Provider.of<SettingsProvider>(context, listen: false)
                          .limitAnimations
                      ? null
                      : BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    // TextField in Stack -> makes button click not focus text field -> OK
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                            style: TextStyle(color: textColor),
                            controller: _nameController,
                            decoration: InputDecoration(
                                labelText: "Nazwa",
                                contentPadding:
                                    const EdgeInsets.fromLTRB(5, 5, 48, 5))),
                        IconButton(
                          tooltip: 'Wylosuj nazwę',
                          icon: Icon(
                            MdiIcons.dice6,
                            size: 20,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _nameController.text = _randomName();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //Get coordinates for markers
                    Row(children: [
                      Expanded(
                          child: TextField(
                              style: TextStyle(color: textColor),
                              controller: _xController,
                              enabled: _selections[1],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  labelText: "X",
                                  contentPadding: const EdgeInsets.all(5)))),
                      SizedBox(width: 2),
                      Expanded(
                          child: TextField(
                              style: TextStyle(color: textColor),
                              controller: _yController,
                              enabled: _selections[1],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  labelText: "Y",
                                  contentPadding: const EdgeInsets.all(5)))),
                      SizedBox(width: 2),
                      ToggleButtons(
                          fillColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white24,
                          selectedColor: textColor,
                          color: textColor,
                          children: [
                            Tooltip(
                                message:
                                    'Aktualne położenie robota (Kliknij by odświeżyć)',
                                child: Icon(MdiIcons.earthBox)),
                            Tooltip(
                                message: 'Ręczne koordynaty',
                                child: Icon(MdiIcons.numeric)),
                            // Tooltip(
                            //     message: 'Przeciągnij znacznik później',
                            //     child: Icon(MdiIcons.gestureTap))
                          ],
                          isSelected: _selections,
                          onPressed: (int index) {
                            setState(() {
                              // _selections[index] = !_selections[index];
                              for (var i = 0; i < _selections.length; i++) {
                                if (i == index) {
                                  _selections[i] = true;
                                } else {
                                  _selections[i] = false;
                                }
                              }
                            });
                          }),
                    ]),
                    SizedBox(height: 15),
                    ColorPickerModified(
                      textColor: textColor,
                      pickerColor: _waypointColor,
                      onColorChanged: (color) => _waypointColor = color,
                      pickerAreaBorderRadius:
                          BorderRadius.all(Radius.circular(2)),
                    ),
                  ]),
            )),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Anuluj", style: TextStyle(color: textColor))),
        FlatButton(
            onPressed: () {
              var waypoint = Waypoint(
                  name: _nameController.text,
                  color: _waypointColor,
                  x: double.parse(_xController.text),
                  y: double.parse(_yController.text),
                  radius: 0.5);
              Navigator.of(context).pop(_isEditMode
                  ? Provider.of<SettingsProvider>(context, listen: false)
                      .editWaypoint(widget.existingWaypoint, waypoint)
                  : Provider.of<SettingsProvider>(context, listen: false)
                      .addToWaypoints(waypoint));
            },
            child: Text(
              "Zapisz",
              style: TextStyle(color: textColor),
            )),
      ],
    );
  }
}
