import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ros_nodes/messages/nav_msgs/OccupancyGrid.dart';

extension CallMeBritney on NavMsgsOccupancyGrid {
  Uint8List toRGBA({@required Color border, @required Color fill}) {
    var buffor = BytesBuilder();
    for (var value in data) {
      switch (value) {
        case -1:
          {
            buffor.add([0, 0, 0, 0]);
            break;
          }
        case 0:
          {
            buffor.add([fill.red, fill.green, fill.blue, fill.alpha]);
            break;
          }
        default:
          {
            buffor.add([border.red, border.green, border.blue, border.alpha]);
            break;
          }
      }
    }
    return buffor.takeBytes();
  }
}
