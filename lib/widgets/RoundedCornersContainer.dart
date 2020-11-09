import 'package:flutter/material.dart';

class RoundedCornersContainer extends StatelessWidget {
  RoundedCornersContainer(
      {Key key,
      @required this.child,
      @required this.top,
      @required this.bottom});

  final Widget child;
  final bool top;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(top ? 10.0 : 0),
          topRight: Radius.circular(top ? 10.0 : 0),
          bottomLeft: Radius.circular(bottom ? 10.0 : 0),
          bottomRight: Radius.circular(bottom ? 10.0 : 0),
        ),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ),
      ),
    );
  }
}
