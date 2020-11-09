import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class StatusInfo extends StatelessWidget {
  const StatusInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Consumer2<SettingsProvider, RosProvider>(
        builder: (context, settingsProvider, rosProvider, child) => Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          children: [
            MiniInfoButton(
              iconData: MdiIcons.lightningBolt,
              text: settingsProvider.topicBattery,
              tooltip: 'Poziom naładowania baterii',
              iconColor: Colors.amberAccent,
            ),
            MiniInfoButton(
              iconData: MdiIcons.arrowUp,
              text: rosProvider.veliocityAvailable
                  ? rosProvider.veliocity.linear.x >= 0
                      ? ' ${rosProvider.veliocity.linear.x.toStringAsFixed(2)}'
                      : rosProvider.veliocity.linear.x.toStringAsFixed(2)
                  : settingsProvider.topicVelocity,
              tooltip: 'Prędkość liniowa',
              iconColor: Colors.greenAccent,
            ),
            MiniInfoButton(
              iconData: MdiIcons.rotateRight,
              text: rosProvider.veliocityAvailable
                  ? rosProvider.veliocity.angular.z.sign >= 0
                      ? ' ${rosProvider.veliocity.angular.z.toStringAsFixed(2)}'
                      : rosProvider.veliocity.angular.z.toStringAsFixed(2)
                  : settingsProvider.topicVelocity,
              tooltip: 'Prędkość kątowa',
              iconColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class MiniInfoButton extends StatelessWidget {
  const MiniInfoButton(
      {Key key,
      @required this.tooltip,
      @required this.text,
      @required this.iconData,
      this.iconColor})
      : assert(text != null),
        assert(iconData != null),
        assert(tooltip != null),
        super(key: key);

  final String tooltip;
  final String text;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).canvasColor),
        child: Chip(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // shape: StadiumBorder(
          //     side: BorderSide(color: Theme.of(context).canvasColor, width: 1)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: EdgeInsets.only(left: 3, right: 4),
          avatar: Icon(iconData,
              size: 18, color: iconColor ?? Theme.of(context).iconTheme.color),
          label: Text(
            text,

            //Theme.of(context).textTheme.caption
            style: Theme.of(context).textTheme.caption,
          ),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
