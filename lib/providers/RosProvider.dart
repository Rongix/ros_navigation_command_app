import 'dart:async';

import 'package:chatapp/models/Message.dart';
import 'package:chatapp/models/Waypoint.dart';
import 'package:chatapp/providers/DialogflowProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ros_nodes/messages/geometry_msgs/PoseStamped.dart';
import 'package:ros_nodes/messages/geometry_msgs/Twist.dart';
import 'package:ros_nodes/messages/nav_msgs/OccupancyGrid.dart';
import 'package:ros_nodes/messages/nav_msgs/Odometry.dart';
import 'package:ros_nodes/messages/sensor_msgs/CompressedImage.dart';
import 'package:ros_nodes/ros_nodes.dart';

import 'dart:ui' as ui;
import 'ChatInfoProvider.dart';
import 'SettingsProvider.dart';
import '../models/NavMsgsOccupancyGridExtension.dart';
import 'package:vector_math/vector_math.dart' show Quaternion, Vector3, radians;

class RosProvider extends ChangeNotifier {
  Waypoint _activeWaypoint;
  Waypoint get activeWaypoint => _activeWaypoint;

  RosConfig _rosConfig;
  RosClient _rosClient;
  RosTopic<GeometryMsgsTwist> _rosTopicVelocity;
  RosTopic<GeometryMsgsTwist> _rosTopicVelocityPublish;
  RosTopic<NavMsgsOccupancyGrid> _rosTopicMap;
  RosTopic<NavMsgsOdometry> _rosTopicOdometry;
  RosTopic<SensorMsgsCompressedImage> _rosTopicCamera;
  RosTopic<PoseStamped> _rosTopicNavigation;

  var _veliocity = GeometryMsgsTwist();
  GeometryMsgsTwist get veliocity => _veliocity;

  var _odometry = NavMsgsOdometry();
  NavMsgsOdometry get odometry => _odometry;

  final _cameraImage = SensorMsgsCompressedImage();
  SensorMsgsCompressedImage get cameraImage => _cameraImage;

  final _mapImage = NavMsgsOccupancyGrid();
  NavMsgsOccupancyGrid get mapImage => _mapImage;

  final velocityPublished = GeometryMsgsTwist();
  RosPublisher _velocityPublisher;

  final _poseStamped = PoseStamped();
  PoseStamped get poseStamped => _poseStamped;

  bool _veliocityAvailable = false;
  bool get veliocityAvailable => _veliocityAvailable;

  bool _odometryAvailable = false;
  bool get odometryAvailable => _odometryAvailable;

  bool _cameraImageAvailable = false;
  bool get cameraImageAvailable => _cameraImageAvailable;

  bool _mapImageAvailable = false;
  bool get mapImageAvailable => _mapImageAvailable;

  void initializeRos(BuildContext context) async {
    //Load ros config from settings to set up primary and secondary device. Then create client to manage topics.
    print(Provider.of<SettingsProvider>(context, listen: false)
        .ipAdressMainServer);
    print(Provider.of<SettingsProvider>(context, listen: false).ipAdressDevice);
    _rosConfig = RosConfig(
      'ros_enabled_device',
      '${Provider.of<SettingsProvider>(context, listen: false).ipAdressMainServer}',
      '${Provider.of<SettingsProvider>(context, listen: false).ipAdressDevice}',
      24125,
    );
    _rosClient = RosClient(_rosConfig);
  }

  void initializeRosTopics(BuildContext context) async {
    _rosTopicOdometry = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicOdometry}',
        NavMsgsOdometry());
    _rosTopicCamera = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicCamera}',
        _cameraImage);
    _rosTopicVelocity = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicVelocity}',
        GeometryMsgsTwist());
    _rosTopicVelocityPublish = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicVelocity}',
        velocityPublished);
    _rosTopicMap = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicMap}',
        _mapImage);
    _rosTopicNavigation = RosTopic(
        '${Provider.of<SettingsProvider>(context, listen: false).topicNavigation}',
        _poseStamped);
    print(_rosTopicNavigation.name);
  }

  void subscribeRosAllTopics(BuildContext context) async {
    initializeRos(context);
    initializeRosTopics(context);
    subscribeRosTopicVelocity();
    publishRosTopicVelocity();
    subscribeRosTopicCamera();
    subscribeRosTopicMap();
    subscribeRosTopicOdometry();
    publishRosTopicNavigation();
    Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
        message: Message(
            // heading: "Próba nawiązania połączenia",
            body: "Połączono z urządzeniem",
            actions: [
              IconWithDescription(
                  onTap: () {
                    print('aaaaaaaaaaaaaaaaaaaaaaaaa');
                  },
                  icon: MdiIcons.refresh,
                  description: 'Aktywowano / odświeżono wszystkie funkcje')
            ],
            sender: Sender.system));
  }

  void unsubscribeRosAllTopics(BuildContext context) async {
    unsubscribeRosTopicVelocity();
    subscribeRosTopicOdometry();
    unsubscribeRosTopicCamera();
    unsubscribeRosTopicNavigation();
    unsubscribeRosTopicMap();
    _rosClient.close();

    Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
        message: Message(
            // heading: "Próba nawiązania połączenia",
            body: "Rozłączono z urządzeniem",
            actions: [
              IconWithDescription(
                  onTap: () {
                    print('bbbbbbbbbbbbbbbbb');
                  },
                  icon: MdiIcons.stop,
                  description:
                      'Anulowano wszystkie akcje. Zatrzymuje urządzenie. Rozłączam system')
            ],
            sender: Sender.system));
  }

  void subscribeRosTopicVelocity() async {
    final _subscriberVelocity = await _rosClient.subscribe(_rosTopicVelocity);
    _subscriberVelocity.onValueUpdate.listen((msg) {
      _veliocity = msg;
      notifyListeners();
    });
    _veliocityAvailable = true;
    notifyListeners();
  }

  void unsubscribeRosTopicVelocity() async {
    await _rosClient.unsubscribe(_rosTopicVelocity);
    _veliocityAvailable = false;
  }

  // Odometry
  void subscribeRosTopicOdometry() async {
    final _subscriberVelocity = await _rosClient.subscribe(_rosTopicOdometry);
    _subscriberVelocity.onValueUpdate.listen((msg) {
      _odometryAvailable = true;
      _odometry = msg;
      notifyListeners();
    });
  }

  void unsubscribeRosTopicOdometry() async {
    await _rosClient.unsubscribe(_rosTopicOdometry);
    _odometryAvailable = false;
  }

  // Camera work
  void subscribeRosTopicCamera() async {
    //FPS
    // var i = 0;
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   print('Camera FPS: $i');
    //   i = 0;
    // });
    var _subscriberCameraImage = await _rosClient.subscribe(_rosTopicCamera);
    _subscriberCameraImage.onValueUpdate.listen((msg) {
      //FPS (26-29)
      // i++;
      _cameraImageAvailable = true;
      notifyListeners();
    });
  }

  void unsubscribeRosTopicCamera() async {
    await _rosClient.unsubscribe(_rosTopicCamera);
    _cameraImageAvailable = false;
  }

  // Navigation goals
  void publishRosTopicNavigation() async {
    print('goal gogo');
    await _rosClient.unregister(_rosTopicNavigation);
    var publisher = await _rosClient.register(_rosTopicNavigation,
        publishInterval: Duration(milliseconds: 500));
  }

  // void subscribeRosTopicNavigation() async {
  //   var subscriber = await _rosClient.subscribe(_rosTopicNavigation);
  //   subscriber.onValueUpdate.listen((msg) {
  //     notifyListeners();
  //   });
  // }

  void unsubscribeRosTopicNavigation() async {
    await _rosClient.unregister(_rosTopicNavigation);
  }

  Future<ui.Image> getMapAsImage(final Color fill, final Color border) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
        _mapImage.toRGBA(fill: fill, border: border),
        _mapImage.info.width,
        _mapImage.info.width,
        ui.PixelFormat.rgba8888,
        completer.complete);
    return completer.future;
  }

  // Map
  void subscribeRosTopicMap() async {
    var _subscriberMapImage = await _rosClient.subscribe(_rosTopicMap);
    _subscriberMapImage.onValueUpdate.listen((msg) {
      _mapImageAvailable = true;
      notifyListeners();
    });
  }

  void unsubscribeRosTopicMap() async {
    await _rosClient.unsubscribe(_rosTopicMap);
    _mapImageAvailable = false;
  }

  void publishRosTopicVelocity() async {
    await _rosClient.unregister(_rosTopicVelocityPublish);
    _velocityPublisher = await _rosClient.register(_rosTopicVelocityPublish,
        publishInterval: Duration(milliseconds: 100));
    //Todo
    // _velocityPublisher.stopPublishing();
  }

  //used by map navigation
  void setactiveWaypoint(Waypoint newWaypoint, BuildContext context) {
    //Waypoint can be reseted to point on map if current goal is canceled
    if (_activeWaypoint != newWaypoint) {
      print('x:${newWaypoint.x}\ty:${newWaypoint.y}');
      var _oldWaypoint = _activeWaypoint;
      _activeWaypoint = newWaypoint;
      _poseStamped
        ..pose.orientation.w = 1
        ..header.frame_id = 'map'
        ..pose.position.x = newWaypoint.x
        ..pose.position.y = newWaypoint.y;

      notifyListeners();
      Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
          message: Message(
              // heading: "Próba nawiązania połączenia",
              body: "Przemieszczam urządzenie",
              actions: [
                IconWithDescription(
                    onTap: () {},
                    icon: MdiIcons.axisArrow,
                    description:
                        'Zmiana celu z \n${_oldWaypoint?.name ?? 'Nowy cel'} na ${_activeWaypoint.name}')
              ],
              sender: Sender.system));
    }
  }

  void setRotationByGoal(Quaternion newRotation, BuildContext context) {
    _activeWaypoint = Waypoint();
    _poseStamped
      ..pose.orientation.x = newRotation.x
      ..pose.orientation.y = newRotation.y
      ..pose.orientation.z = newRotation.z
      ..pose.orientation.w = newRotation.w
      ..header.frame_id = 'map'
      ..pose.position.x = _odometry.pose.pose.position.x
      ..pose.position.y = _odometry.pose.pose.position.y;

    notifyListeners();
  }

  //Get result from AI message and pick correct action to execute
  void matchIntent(CustomAIResponse aiResponse, BuildContext context) {
    print('Intent matching');

    if (aiResponse.queryResult.allRequiredParamsPresent ?? false) {
      print(aiResponse.queryResult.intent.displayName);
      switch (aiResponse.queryResult.intent.displayName) {
        case 'test':
          {
            Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
                message: Message(
                    // heading: "Próba nawiązania połączenia",
                    body: "Exec: ${aiResponse.queryResult.intent.displayName}",
                    actions: [
                      IconWithDescription(
                          onTap: () {},
                          icon: MdiIcons.testTube,
                          description: _mapImageAvailable &&
                                  _cameraImageAvailable
                              ? 'Wykryto polecenie testowe. 100% pewności na gotowość do działania'
                              : 'Wykryto polecenie testowe. Niektóre komponenty aplikacji nie działają poprawnie:'),
                      _mapImageAvailable
                          ? null
                          : IconWithDescription(
                              onTap: () {},
                              icon: Icons.warning,
                              description:
                                  'Nie można połączyć się z mapą. Spróbuj odświeżyć połączenie oraz wypełnić nazwy tematów w ustawieniach'),
                      _cameraImageAvailable
                          ? null
                          : IconWithDescription(
                              onTap: () {},
                              icon: Icons.warning,
                              description:
                                  'Nie można połączyć się z kamerą. Spróbuj odświeżyć połączenie oraz wypełnić nazwy tematów w ustawieniach'),
                    ],
                    sender: Sender.system));
            break;
          }
        case 'WaypointNavigation':
          {
            // print(aiResponse.queryResult.parameters['pomieszczenietyp']);
            setactiveWaypoint(
                Provider.of<SettingsProvider>(context, listen: false)
                    .findWaypointByName(
                        aiResponse.queryResult.parameters['pomieszczenietyp']),
                context);
            break;
          }
        case 'rotacjaRobota':
          {
            var robotOdom = _odometry;
            var robotRotation = Quaternion(
                robotOdom.pose.pose.orientation.x,
                robotOdom.pose.pose.orientation.y,
                robotOdom.pose.pose.orientation.z,
                robotOdom.pose.pose.orientation.w);

            print(robotRotation.radians / 0.017453292519);

            var direction =
                aiResponse.queryResult.parameters['kierunekrotacji'];
            var newAngle = 0.0;
            switch (direction) {
              case 'prawo':
                {
                  newAngle =
                      (aiResponse.queryResult.parameters['number'] as int)
                          .toDouble();
                  break;
                }
              case 'lewo':
                {
                  newAngle =
                      -(aiResponse.queryResult.parameters['number'] as int)
                          .toDouble();
                  break;
                }
            }
            robotRotation *=
                Quaternion.axisAngle(Vector3(0, 0, -1), radians(newAngle));
            print(robotRotation.radians / 0.017453292519);

            setRotationByGoal(robotRotation, context);

            Provider.of<ChatInfoProvider>(context, listen: false).addMessage(
                message: Message(
                    body: "Exec: ${aiResponse.queryResult.intent.displayName}",
                    actions: [
                      IconWithDescription(
                          onTap: () {},
                          icon: MdiIcons.rotate3D,
                          description: 'Obracam robota o $newAngle'),
                    ],
                    sender: Sender.system));

            break;
          }
        default:
          {
            print('intent not qualified by execution rules');
            break;
          }
      }
    } else {
      print('Not all params supplied or not qualified to execution');
    }
  }
}
