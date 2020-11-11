import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/providers/RosProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/RainbowCircularIndicator.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:chatapp/widgets/StatusInfo.dart';
import 'package:chatapp/widgets/WirtualController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerPage extends StatelessWidget {
  const ControllerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            fit: StackFit.expand,
            children: [
              Consumer2<SettingsProvider, RosProvider>(
                builder: (ctx, settingsProvider, rosProvider, child) =>
                    Container(
                  child: rosProvider.cameraImageAvailable
                      ? Image.memory(
                          rosProvider.cameraImage.data,
                          gaplessPlayback: true,
                          fit: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? BoxFit.fitHeight
                              : BoxFit.fitWidth,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(S?.of(context)?.pageControllerInfoTitle,
                                style: Theme.of(context).textTheme.subtitle1,
                                textAlign: TextAlign.center),
                            Text('${settingsProvider.topicCamera}',
                                style: Theme.of(context).textTheme.caption,
                                textAlign: TextAlign.center),
                            SizedBox(
                              height: 15,
                            ),
                            RainbowCircularIndicator()
                          ],
                        ),
                ),
              ),
              StatusInfo(),
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: _JoystickConfigurationLandscape())
                  : SizedBox(),
            ],
          ),
        ),
        ShadowLine(),
        MediaQuery.of(context).orientation == Orientation.portrait
            ? _JoystickConfigurationPortrait()
            : SizedBox(),
      ],
    );
  }
}

class _JoystickConfigurationPortrait extends StatelessWidget {
  const _JoystickConfigurationPortrait({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: MediaQuery.of(context).size.height / 3.6,
      child: Center(
        child: Container(
          child: WirtualController(
            baseSize: MediaQuery.of(context).size.height / 3.9,
            stickSize: MediaQuery.of(context).size.height / 3.9 * 0.4,
            onStickMove: (offset) {
              joystickMove(offset, context);
            },
          ),
        ),
      ),
    );
  }
}

class _JoystickConfigurationLandscape extends StatelessWidget {
  const _JoystickConfigurationLandscape({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        color: Colors.transparent,
        // height: MediaQuery.of(context).size.height / 4,
        child: Container(
          child: WirtualController(
            baseSize: MediaQuery.of(context).size.height / 2.5,
            stickSize: MediaQuery.of(context).size.height / 2.5 * 0.4,
            onStickMove: (offset) {
              joystickMove(offset, context);
            },
          ),
        ),
      ),
    );
  }
}

void joystickMove(Offset offset, BuildContext context) {
  var msg = Provider.of<RosProvider>(context, listen: false).velocityPublished;

  msg.linear.x = -offset.dy * 0.4;
  msg.angular.z = -offset.dx;
}
