import 'package:chatapp/models/Message.dart';
import 'package:chatapp/providers/AudioProvider.dart';
import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/StringExtension.dart';
import 'package:vector_math/vector_math.dart' show radians;

class BubbleMessage extends StatefulWidget {
  final Message message;

  const BubbleMessage({Key key, @required this.message}) : super(key: key);

  @override
  _BubbleMessageState createState() => _BubbleMessageState();
}

class _BubbleMessageState extends State<BubbleMessage>
    with TickerProviderStateMixin {
  var selected = false;
  var opacity = 0.0;

  Widget slideIn(Widget child) {
    return Column(
      children: [
        AnimatedSize(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 200),
          vsync: this,
          curve: Curves.linear,
          child: Container(
            constraints: selected
                ? BoxConstraints(maxHeight: double.infinity)
                : BoxConstraints(maxHeight: 0.0),
            child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opacity,
                curve: Curves.easeOutQuad,
                child: child),
          ),
        ),
      ],
    );
  }

  Widget timeStamp() {
    return slideIn(Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Text(DateFormat.Hm().format(widget.message.timestamp),
          style: Theme.of(context).textTheme.caption),
    ));
  }

  Widget parameterShelf() {
    return slideIn(Builder(
      builder: (_) {
        var textTheme = Theme.of(context).textTheme.caption;
        var fulfilled =
            widget.message.aiResponse.queryResult.allRequiredParamsPresent;
        var intentType =
            widget.message.aiResponse.queryResult.intent.displayName;
        fulfilled ??= false;

        var status = fulfilled
            ? Chip(
                shape: StadiumBorder(
                    side: BorderSide(
                        width: 0.5,
                        color: Colors.greenAccent[400].withOpacity(0.5))),
                backgroundColor: Theme.of(context).canvasColor,
                visualDensity: VisualDensity.compact,
                label: Text("Zrobione", style: textTheme),
                avatar:
                    Icon(MdiIcons.checkBold, color: Colors.greenAccent[400]),
              )
            : Chip(
                shape: StadiumBorder(
                    side: BorderSide(
                        width: 0.5, color: Colors.red[400].withOpacity(0.5))),
                backgroundColor: Theme.of(context).canvasColor,
                visualDensity: VisualDensity.compact,
                label: Text("Czekam na parametry", style: textTheme),
                avatar: Icon(MdiIcons.timelapse, color: Colors.red[400]));
        var intentTypeChip = Chip(
          shape: StadiumBorder(
              side: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).accentColor.withOpacity(0.5))),
          backgroundColor: Theme.of(context).canvasColor,
          visualDensity: VisualDensity.compact,
          label: Text(intentType, style: textTheme),
          avatar:
              Icon(Icons.question_answer, color: Theme.of(context).accentColor),
        );

        var children = <Widget>[
          status,
          intentTypeChip,
        ];

        var params = widget.message.aiResponse.queryResult.parameters;

        params.forEach(
          (k, v) {
            // k = StringUtils.capitalize(k);
            v = v.toString();
            var isWord = RegExp(r"^\w");
            if (isWord.firstMatch(v) != null) {
              // v = StringUtils.capitalize(v);
            }
            children.add(
              Chip(
                shape: StadiumBorder(
                    side: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).accentColor.withOpacity(0.5))),
                backgroundColor: Theme.of(context).canvasColor,
                avatar: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Icon(MdiIcons.package,
                      color: Colors.grey.withOpacity(0.8)),
                ),
                visualDensity: VisualDensity.compact,
                label: Text(
                  '$k : $v',
                  style: textTheme,
                ),
              ),
            );
          },
        );
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: Container(
              // color: Theme.of(context).accentColor.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      children: children,
                      spacing: 5,
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.message.sender == Sender.system
        ? SystemInfo(
            message: widget.message,
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                selected = !selected;
                if (selected) {
                  opacity = 1.0;
                } else {
                  opacity = 0.0;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
              child: Column(
                crossAxisAlignment: widget.message.sender == Sender.user
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  // Show message details: Datetime
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: timeStamp(),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: widget.message.sender == Sender.user
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        //Play stop icon for user message
                        widget.message.sender == Sender.user &&
                                widget.message.voiceActing != null
                            ? Consumer<AudioProvider>(
                                builder: (context, provider, child) =>
                                    AnimatedSwitcher(
                                  duration: Duration(milliseconds: 100),
                                  child: selected
                                      ? IconButton(
                                          visualDensity: VisualDensity(
                                              horizontal: -4, vertical: -4),
                                          padding: EdgeInsets.zero,
                                          tooltip:
                                              "Odtwórz wiadomość głosową użytkownika",
                                          icon: Icon(
                                            Icons.play_arrow_rounded,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          onPressed: () {
                                            provider.playBubbleUserMessageVoice(
                                                widget
                                                    .message.voiceActing.path);
                                          },
                                        )
                                      : SizedBox(),
                                ),
                              )
                            : SizedBox(),
                        //Message body
                        MessageBody(widget: widget),
                        //Play stop icon for bot
                        widget.message.sender == Sender.bot &&
                                widget.message.aiResponse.outputAudio != null
                            ? Consumer<AudioProvider>(
                                builder: (context, provider, child) =>
                                    AnimatedSwitcher(
                                  duration: Duration(milliseconds: 100),
                                  child: selected
                                      ? IconButton(
                                          padding: EdgeInsets.zero,
                                          visualDensity: VisualDensity(
                                              horizontal: -4, vertical: -4),
                                          tooltip:
                                              "Odtwórz wiadomość głosową robota",
                                          icon: Icon(
                                            Icons.play_arrow_rounded,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .color,
                                          ),
                                          onPressed: () {
                                            provider.playBubbleBotMessageVoice(
                                                widget.message.aiResponse
                                                    .outputAudio);
                                          },
                                        )
                                      : SizedBox(),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  widget.message.sender == Sender.bot
                      ? parameterShelf()
                      : SizedBox(),
                ],
              ),
            ),
          );
  }
}

class MessageBody extends StatelessWidget {
  const MessageBody({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final BubbleMessage widget;

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.message.sender == Sender.user
        ? Theme.of(context).accentColor.computeLuminance() > 0.4
            ? Colors.black.withOpacity(0.6)
            : Colors.white
        : Theme.of(context).canvasColor.computeLuminance() > 0.5
            ? Colors.black.withOpacity(0.6)
            : Colors.white;
    var textTheme = Theme.of(context)
        .textTheme
        .subtitle1
        .merge(TextStyle(color: textColor));
    return Consumer<ChatInfoProvider>(
      builder: (context, chatInfoProvider, child) => Tooltip(
        message:
            // 'Wiadomość od ${widget.message.isUser ? 'użytkownika' : 'robota'}:\n${widget.message.text}',
            'Wiadomość od ${widget.message.sender == Sender.user ? 'użytkownika' : 'robota'}',
        child: Material(
          color: widget.message.sender == Sender.user
              ? Theme.of(context).accentColor
              : null,
          elevation: 0.5,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.618),
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: widget.message.sender == Sender.user &&
                    widget.message.voiceActing != null
                ? widget.message.body == 'Wiadomość głosowa bez transkrypcji'
                    ? Icon(MdiIcons.waveform,
                        size: 18 * MediaQuery.of(context).textScaleFactor,
                        color: textColor)
                    : Wrap(children: <Widget>[
                        Icon(MdiIcons.waveform,
                            size: 18 * MediaQuery.of(context).textScaleFactor,
                            color: textColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            // Automatic transcription from voice
                            widget.message.body.capitalize(),
                            style: textTheme,
                          ),
                        ),
                      ])
                : Text(
                    widget.message.body,
                    style: textTheme,
                  ),
          ),
        ),
      ),
    );
  }
}

class SystemInfo extends StatelessWidget {
  final Message message;
  const SystemInfo({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      //Cant clip corners other way, it should be reworked if possible
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 50),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        message.heading != null
                            ? Text(
                                // 'Witaj',
                                message.heading,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .color)),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(),
                        //Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            message.body,
                            // 'W tym oknie możesz prowadzić rozmowę z robotem asystentem. Aby rozpocząć',
                            style: Theme.of(context).textTheme.subtitle1.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .color)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //Generate actions
                        ...message.actions?.map((item) {
                              return item != null
                                  ? ActionButton(
                                      iconData: item.icon,
                                      text: item.description,
                                      onTap: () {},
                                    )
                                  : SizedBox();
                            }) ??
                            []
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                    angle: radians(180),
                    child: CustomPaint(
                      painter:
                          RibbonPainter(color: Theme.of(context).accentColor),
                      child: Container(
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomPaint(
              painter: RibbonPainter(color: Theme.of(context).accentColor),
              child: Container(
                height: 50,
                width: 50,
              ),
            ),
            Tooltip(
              message: 'System:call',
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    // MdiIcons.hammerScrewdriver,
                    MdiIcons.bell,
                    color: Colors.black54,
                    size: 18,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  ActionButton(
      {Key key,
      @required this.iconData,
      @required this.text,
      @required this.onTap})
      : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onTap: () {
          print('testTestActionButton@0');
        },
        visualDensity: VisualDensity.compact,
        dense: true,
        leading: Icon(
          widget.iconData,
          color: Theme.of(context).textTheme.headline4.color,
        ),
        title: Text(widget.text,
            style: Theme.of(context).textTheme.caption.merge(
                TextStyle(color: Theme.of(context).textTheme.headline4.color))),
      ),
    );
  }
}

//Custom ribbon shape on top of system messages. It can't be achieved with ClipRRect when container is small
//also there is a problem with bleeding colors.
class RibbonPainter extends CustomPainter {
  final Color color;

  Paint trianglePaint;

  RibbonPainter({@required this.color}) {
    trianglePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var bigTris = Path();
    bigTris.lineTo(size.width, 0);
    bigTris.lineTo(0, size.height + 20);

    bigTris.lineTo(0, 5);
    // bigTris.arcToPoint(Offset(5, 0), radius: Radius.circular(5));
    bigTris.close();
    canvas.drawPath(
        bigTris, trianglePaint..color = trianglePaint.color.withOpacity(0.5));

    var smallTris = Path();
    smallTris.lineTo(size.width, 0);
    smallTris.lineTo(0, size.height);

    smallTris.lineTo(0, 5);
    // bigTris.arcToPoint(Offset(5, 0), radius: Radius.circular(5));
    smallTris.close();
    canvas.drawPath(
        smallTris, trianglePaint..color = trianglePaint.color.withOpacity(1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void drawTriangle(Canvas canvas, Size size, double height, Paint paint) {}
}
