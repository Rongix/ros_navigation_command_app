import 'package:flutter/material.dart';

class ShadowLine extends StatelessWidget {
  const ShadowLine({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      thickness: 1,
      // color: Theme.of(context).brightness == Brightness.light
      //     ? Colors.black26
      //     : Colors.black87,
    );
  }
}
