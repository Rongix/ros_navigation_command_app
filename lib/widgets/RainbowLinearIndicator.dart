import 'package:flutter/material.dart';

class RainbowLinearIndicator extends StatefulWidget {
  RainbowLinearIndicator({Key key}) : super(key: key);

  @override
  _RainbowLinearIndicatorState createState() => _RainbowLinearIndicatorState();
}

class _RainbowLinearIndicatorState extends State<RainbowLinearIndicator>
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
    return LinearProgressIndicator(
      valueColor:
          ColorTween(begin: Theme.of(context).accentColor, end: Colors.amber)
              .animate(_controller),
    );
  }
}
