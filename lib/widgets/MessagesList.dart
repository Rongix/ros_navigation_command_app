import 'package:chatapp/providers/ChatInfoProvider.dart';
import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/BubbleMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messageslist extends StatelessWidget {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatInfoProvider>(context, listen: false).addListener(
      () async {
        await Future.delayed(Duration(milliseconds: 250));
        if (controller.positions.isEmpty) return;
        if (WidgetsBinding.instance.disableAnimations) {
          controller.jumpTo(
            controller.position.maxScrollExtent,
          );
        } else {
          controller.animateTo(controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      },
    );
    return Flexible(
      child: Consumer<ChatInfoProvider>(
        builder: (context, provider, child) => AnimatedList(
          physics: Provider.of<SettingsProvider>(context, listen: false)
                      .limitAnimations ??
                  false
              ? null
              : BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 5, bottom: 20, left: 0, right: 0),
          key: provider.listKey,
          reverse: false,
          controller: controller,
          initialItemCount: provider.messages.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1.5),
                end: Offset.zero,
              ).animate(animation),
              child: BubbleMessage(
                message: provider.messages[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
