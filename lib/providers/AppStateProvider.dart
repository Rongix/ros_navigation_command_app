import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/screens/ChatPage.dart';
import 'package:chatapp/screens/ControllerPage.dart';
import 'package:chatapp/screens/MapPage.dart';
import 'package:flutter/cupertino.dart';

class AppStateProvider extends ChangeNotifier {
  var _activePageIndex = 0;
  static const _appPages = [ChatPage(), ControllerPage(), MapPage()];

  var _navigationBarPageController =
      PageController(initialPage: 0, keepPage: true);

  void setActivePage(int index) {
    if (index != _activePageIndex) {
      _activePageIndex = index;
      // Navigation with PagedView
      // if (WidgetsBinding.instance.disableAnimations) {
      //   _navigationBarPageController.jumpToPage(index);
      // } else {
      //   _navigationBarPageController.animateToPage(index,
      //       duration: Duration(milliseconds: 400), curve: Curves.easeOutQuad);
      // }
      notifyListeners();
    }
  }

  int get activePageIndex => _activePageIndex;
  PageController get navigationBarPageController =>
      _navigationBarPageController;
  List<Widget> get appPages => _appPages;
}
