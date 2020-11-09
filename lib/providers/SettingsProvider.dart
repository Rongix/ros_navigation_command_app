import 'package:chatapp/models/Waypoint.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // JSON storage for objects like Waypoints
  bool _localAppStorageInitialized = false;
  get localAppStorageInitialized => _localAppStorageInitialized;

  WaypointList _waypoints;

  WaypointList get waypoints => _waypoints;

  void addToWaypoints(Waypoint waypoint) {
    _waypoints.waypoints.add(waypoint);
    notifyListeners();
  }

  void editWaypoint(Waypoint oryginal, Waypoint edited) {
    var index =
        _waypoints.waypoints.indexWhere((element) => element == oryginal);
    print('found the same waypoint');
    _waypoints.waypoints.remove(oryginal);
    _waypoints.waypoints.insert(index, edited);
    notifyListeners();
  }

  Waypoint findWaypointByName(String name) {
    return _waypoints.waypoints.elementAt(
        _waypoints.waypoints.indexWhere((element) => element.name == name));
  }

  void removeWaypoint(Waypoint waypoint) {
    _waypoints.waypoints.remove(waypoint);
    notifyListeners();
  }

  // Shared preferences settings
  bool _initialized = false;

  int _themeModeIndex;
  int get themeModeIndex => _themeModeIndex;

  ThemeMode _appTheme;
  ThemeMode get appTheme => _appTheme;

  bool _limitAnimations;
  bool get limitAnimations => _limitAnimations;

  bool _showNavigationBarLabels;
  bool get showNavigationBarLabels => _showNavigationBarLabels;

  bool _useTopicsOverWebView;
  bool get useTopicsOverWebView => _useTopicsOverWebView;

  bool _showMapGrid;
  bool get showMapGrid => _showMapGrid;

  // Textfields controller strings
  String _ipAdressMainServer;
  String get ipAdressMainServer => _ipAdressMainServer;

  String _ipAdressDevice;
  String get ipAdressDevice => _ipAdressDevice;

  String _topicOdometry;
  String get topicOdometry => _topicOdometry;

  String _topicCamera;
  String get topicCamera => _topicCamera;

  String _topicBattery;
  String get topicBattery => _topicBattery;

  String _topicVelocity;
  String get topicVelocity => _topicVelocity;

  String _topicMap;
  String get topicMap => _topicMap;

  String _topicNavigation;
  String get topicNavigation => _topicNavigation;

  String _topicChatter;
  String get topicChatter => _topicChatter;

  String _webCameraAdress;
  String get webCameraAdress => _webCameraAdress;

  String _webMapAdress;
  String get webMapAdress => _webMapAdress;

  void _initializeTheme() {
    switch (_themeModeIndex) {
      case 0:
        {
          _appTheme = ThemeMode.light;

          break;
        }
      case 1:
        {
          _appTheme = ThemeMode.dark;
          break;
        }
      case 2:
        {
          _appTheme = ThemeMode.system;
          break;
        }
    }
  }

  void _saveTheme() {
    switch (_appTheme) {
      case ThemeMode.light:
        {
          _themeModeIndex = 0;
          break;
        }
      case ThemeMode.dark:
        {
          _themeModeIndex = 1;
          break;
        }
      case ThemeMode.system:
        {
          _themeModeIndex = 2;
          break;
        }
    }
  }

  // Run on app start
  // Load saved preferences from Shared preferences
  Future prefsInitialize() async {
    if (!_initialized) {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      _themeModeIndex = prefs.getInt('themeModeIndex') ?? 2;
      _initializeTheme();
      _limitAnimations = prefs.getBool('limitAnimations') ?? false;
      _showNavigationBarLabels =
          prefs.getBool('showNavigationBarLabels') ?? false;
      _useTopicsOverWebView = prefs.getBool('useTopicsOverWebView') ?? true;

      // Set controllers strings
      _ipAdressMainServer =
          prefs.getString('ipAdressMainServer') ?? 'http://192.168.1.11:11311/';
      _ipAdressDevice = prefs.getString('ipAdressDevice') ?? '192.168.1.30';
      _topicOdometry = prefs.getString('topicOdometry') ?? 'odom';
      _topicCamera =
          prefs.getString('topicCamera') ?? 'camera/rgb/image_raw/compressed';
      _topicBattery = prefs.getString('topicBattery') ?? 'battery_state';
      _topicVelocity = prefs.getString('topicVelocity') ?? 'cmd_vel';
      _topicMap = prefs.getString('topicMap') ?? 'map';
      _topicNavigation =
          prefs.getString('topicNavigation') ?? 'move_base_simple/goal';
      _topicChatter = prefs.getString('topicChatter') ?? 'chatter';
      _webCameraAdress = prefs.getString('webCameraAdress') ?? '';
      _webMapAdress = prefs.getString('webMapAdress') ?? '';

      // Map View
      _showMapGrid = prefs.getBool('showMapGrid') ?? false;
      _initialized = true;
    }
  }

  void localStorageInitialize() {
    final localAppStorage = LocalStorage('localAppStorage');
    if (!_localAppStorageInitialized) {
      // Waypoints from sample turtlebot3 home 3d simulated environmental map, based on true storry
      _waypoints = localAppStorage.getItem('waypoints') ??
          WaypointList([
            Waypoint(name: 'kuchnia', color: Colors.green, x: 6, y: -1),
            Waypoint(
                name: 'pokój gościnny', color: Colors.yellow, x: 2.9, y: 2.3),
            Waypoint(name: 'sypialnia', color: Colors.pink, x: -6, y: 3.11),
            Waypoint(name: 'łazienka', color: Colors.blue, x: 1, y: 2.6),
          ]);

      _localAppStorageInitialized = true;
    }
  }

  void localStorageSave() async {
    final localAppStorage = LocalStorage('localAppStorage');
    await localAppStorage.setItem('waypoints', _waypoints);
  }

  // Run on back button from settings if not saved
  // Save current preferences to Shared preferences
  void savePrefs() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    _saveTheme();
    prefs.setInt('themeModeIndex', themeModeIndex);
    prefs.setBool('limitAnimations', limitAnimations);
    prefs.setBool('showNavigationBarLabels', showNavigationBarLabels);
    prefs.setBool('useTopicsOverWebView', useTopicsOverWebView);
    prefs.setString('ipAdressMainServer', ipAdressMainServer);
    prefs.setString('ipAdressDevice', ipAdressDevice);
    prefs.setString('topicOdometry', topicOdometry);
    prefs.setString('topicCamera', topicCamera);
    prefs.setString('topicBattery', topicBattery);
    prefs.setString('topicVelocity', topicVelocity);
    prefs.setString('topicMap', topicMap);
    prefs.setString('topicNavigation', topicNavigation);
    prefs.setString('topicChatter', topicChatter);
    prefs.setString('webCameraAdress', webCameraAdress);
    prefs.setString('webMapAdress', webMapAdress);

    // Map View
    prefs.setBool('showMapGrid', showMapGrid);

    notifyListeners();
  }

  void setTheme(ThemeMode value) {
    _appTheme = value;
    notifyListeners();
  }

  void setLimitAnimations(bool value) {
    _limitAnimations = value;
    notifyListeners();
  }

  void setShowNavigationBarLabels(bool value) {
    _showNavigationBarLabels = value;
    notifyListeners();
  }

  void setUseTopicsOverWebView(bool value) {
    _useTopicsOverWebView = value;
    notifyListeners();
  }

  void setIpAdressMainServer(String str) {
    print('Set ip main server to $str');
    _ipAdressMainServer = str;
  }

  void setIpAdressDevice(String str) {
    _ipAdressDevice = str;
  }

  void setTopicOdometry(String str) {
    _topicOdometry = str;
  }

  void setTopicCamera(String str) {
    _topicCamera = str;
  }

  void setTopicBattery(String str) {
    _topicBattery = str;
  }

  void setTopicVelocity(String str) {
    _topicVelocity = str;
  }

  void setTopicMap(String str) {
    _topicMap = str;
  }

  void setTopicNavigation(String str) {
    _topicNavigation = str;
  }

  void setTopicChatter(String str) {
    _topicChatter = str;
  }

  void setWebCameraAdress(String str) {
    _webCameraAdress = str;
  }

  void setWebMapAdress(String str) {
    _webMapAdress = str;
  }

  void toggleMapGrid() {
    _showMapGrid = !_showMapGrid;
    notifyListeners();
  }
}
