/// HSV(HSB)/HSL Color Picker example
///
/// You can create your own layout by importing `hsv_picker.dart`.
/// BASED ON @mchome https://github.com/mchome/flutter_colorpicker
/// https://pub.flutter-io.cn/packages/flutter_colorpicker/example

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerModified extends StatefulWidget {
  final double width;
  final double height;
  final Color pickerColor;
  final BorderRadius pickerAreaBorderRadius;
  final ValueChanged<Color> onColorChanged;
  final Color textColor;
  final String hueLabel;

  const ColorPickerModified({
    @required this.pickerColor,
    @required this.onColorChanged,
    @required this.textColor,
    @required this.hueLabel,
    this.width: 300.0,
    this.height: 200.0,
    this.pickerAreaBorderRadius: const BorderRadius.all(Radius.zero),
  }) : assert(pickerAreaBorderRadius != null);

  @override
  _ColorPickerModifiedState createState() => _ColorPickerModifiedState();
}

class _ColorPickerModifiedState extends State<ColorPickerModified> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  var _r = TextEditingController();
  var _g = TextEditingController();
  var _b = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
    var color = currentHsvColor.toColor();

    _r.value = TextEditingValue(text: color.red.toString());
    _g.value = TextEditingValue(text: color.green.toString());
    _b.value = TextEditingValue(text: color.blue.toString());
  }

  Widget colorPickerArea() {
    return ClipRRect(
        borderRadius: widget.pickerAreaBorderRadius,
        child: ColorPickerArea(
          currentHsvColor,
          (HSVColor color) {
            setState(() => currentHsvColor = color);
            updateColor(color.toColor());
          },
          PaletteType.hsv,
        ));
  }

  void updateColor(Color color) {
    _r.value = TextEditingValue(text: color.red.toString());
    _g.value = TextEditingValue(text: color.green.toString());
    _b.value = TextEditingValue(text: color.blue.toString());
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    var currentColor = currentHsvColor.toColor();

    return Column(
      children: <Widget>[
        SizedBox(
            width: widget.width,
            height: widget.height,
            child: colorPickerArea()),
        Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 5, left: 0, right: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                          borderRadius: widget.pickerAreaBorderRadius,
                          color: currentColor)),
                  Expanded(
                      child: SizedBox(
                          height: 48.0,
                          width: widget.width,
                          child: SliderTheme(
                              data: Theme.of(context).sliderTheme.copyWith(
                                  trackShape: RectangularSliderTrackShape(),
                                  trackHeight: 2),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      widget.hueLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline
                                          .merge(TextStyle(
                                              color: widget.textColor)),
                                    ),
                                  ),
                                  Slider(
                                      activeColor: currentHsvColor.toColor(),
                                      min: 0,
                                      max: 360,
                                      value: currentHsvColor.hue,
                                      onChanged: (double value) {
                                        setState(() {
                                          currentHsvColor = HSVColor.fromAHSV(
                                              currentHsvColor.alpha,
                                              value,
                                              currentHsvColor.saturation,
                                              currentHsvColor.value);
                                        });
                                        updateColor(currentHsvColor.toColor());
                                      }),
                                ],
                              ))))
                ])),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: TextField(
                    style: TextStyle(color: widget.textColor),
                    controller: _r,
                    keyboardType: TextInputType.number,
                    onSubmitted: (text) {
                      setState(() {
                        var red = int.parse(text);
                        currentHsvColor = HSVColor.fromColor(Color.fromRGBO(
                            red, currentColor.green, currentColor.blue, 1));
                      });
                      updateColor(currentHsvColor.toColor());
                    },
                    decoration: InputDecoration(
                        labelText: "R",
                        contentPadding: const EdgeInsets.all(5)))),
            SizedBox(
              width: 2,
            ),
            Expanded(
                child: TextField(
                    style: TextStyle(color: widget.textColor),
                    controller: _g,
                    keyboardType: TextInputType.number,
                    onSubmitted: (text) {
                      setState(() {
                        var green = int.parse(text);
                        currentHsvColor = HSVColor.fromColor(Color.fromRGBO(
                            currentColor.red, green, currentColor.blue, 1));
                      });
                      updateColor(currentHsvColor.toColor());
                    },
                    decoration: InputDecoration(
                        labelText: "G",
                        contentPadding: const EdgeInsets.all(5)))),
            SizedBox(
              width: 2,
            ),
            Expanded(
                child: TextField(
                    style: TextStyle(color: widget.textColor),
                    controller: _b,
                    keyboardType: TextInputType.number,
                    onSubmitted: (text) {
                      setState(() {
                        var blue = int.parse(text);
                        currentHsvColor = HSVColor.fromColor(Color.fromRGBO(
                            currentColor.red, currentColor.green, blue, 1));
                      });
                      updateColor(currentHsvColor.toColor());
                    },
                    decoration: InputDecoration(
                        labelText: "B",
                        contentPadding: const EdgeInsets.all(5)))),
          ],
        )
      ],
    );
  }
}
