import 'package:flutter/material.dart';

class RainbowCircularIndicator extends StatefulWidget {
  RainbowCircularIndicator({Key key}) : super(key: key);

  @override
  _RainbowCircularIndicatorState createState() =>
      _RainbowCircularIndicatorState();
}

class _RainbowCircularIndicatorState extends State<RainbowCircularIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 2000),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: ColorTween(
              begin: Theme.of(context).accentColor,
              end: Theme.of(context).brightness == Brightness.light
                  ? Colors.pinkAccent[100]
                  : Colors.amber)
          .animate(_controller),
    );
  }
}
