import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPageNew extends StatelessWidget {
  const SettingsPageNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark),
      child: Theme(
        data: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context)
                .copyWith(primaryColor: Theme.of(context).accentColor)
            : Theme.of(context),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0), child: ShadowLine()),
            toolbarHeight:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 50
                    : 40,
            leading: IconButton(
              onPressed: () {
                Provider.of<SettingsProvider>(context, listen: false)
                    .savePrefs();
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left),
            ),
            backgroundColor: Theme.of(context).canvasColor,
            title: Text("Ustawienia"),
          ),
          body: ListView(
            physics: Provider.of<SettingsProvider>(context, listen: false)
                    .limitAnimations
                ? null
                : BouncingScrollPhysics(),
            children: [
              ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.apps),
                  ),
                  title: Text('Ustawienia aplikacji'),
                  subtitle: Text('Ogólne ustawienia i akcesyjność')),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) => RadioListTile(
                  groupValue: settingsProvider.appTheme,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    settingsProvider.setTheme(value);
                  },
                  title: Text("Jasny motyw"),
                  value: ThemeMode.light,
                ),
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) => RadioListTile(
                  groupValue: settingsProvider.appTheme,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    settingsProvider.setTheme(value);
                  },
                  title: Text("Ciemny motyw"),
                  value: ThemeMode.dark,
                ),
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) => RadioListTile(
                  groupValue: settingsProvider.appTheme,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    settingsProvider.setTheme(value);
                  },
                  title: Text("Systemowy motyw"),
                  value: ThemeMode.system,
                ),
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) => ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.animation),
                  ),
                  onTap: () {
                    settingsProvider
                        .setLimitAnimations(!settingsProvider.limitAnimations);
                  },
                  title: Text('Ogranicz animacje'),
                  subtitle: Text('Zmienia zachowanie list, wiadomości'),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: settingsProvider.limitAnimations,
                    onChanged: (bool value) {
                      settingsProvider.setLimitAnimations(value);
                    },
                  ),
                ),
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) => ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.smart_button),
                  ),
                  onTap: () {
                    settingsProvider.setShowNavigationBarLabels(
                        !settingsProvider.showNavigationBarLabels);
                  },
                  title: Text('Podpisy przycisków'),
                  subtitle: Text('Dodaje podpisy pod przyciskami nawigacji'),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: settingsProvider.showNavigationBarLabels,
                    onChanged: (bool value) {
                      settingsProvider.setShowNavigationBarLabels(value);
                    },
                  ),
                ),
              ),
              SettingsDivider(),
              ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(MdiIcons.desktopTower),
                  ),
                  title: Text('Konfiguracja ROS'),
                  subtitle: Text(
                      'Konfiguracja sieciowa ROS, należy wprowadzić adres urządzenia roscore i adres ip aktualnego urządzenia')),
              ListTileTextField(
                icon: Icon(MdiIcons.server),
                title: Text('Główny serwer (IP)'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setIpAdressMainServer(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .ipAdressMainServer,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.devices),
                title: Text('To urządzenie (IP)'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setIpAdressDevice(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .ipAdressDevice,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.cube),
                title: Text('Odometria robota'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicOdometry(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicOdometry,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.camera),
                title: Text('Kamera'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicCamera(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicCamera,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.battery),
                title: Text('Bateria'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicBattery(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicBattery,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.speedometer),
                title: Text('Prędkość liniowa / kątowa silników'),
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicVelocity(str);
                },
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicVelocity,
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.earthBox),
                title: Text('Mapa'),
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicMap,
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicMap(str);
                },
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.navigation),
                title: Text('Nawigacja / Cel'),
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicNavigation,
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicNavigation(str);
                },
              ),
              ListTileTextField(
                icon: Icon(MdiIcons.chat),
                title: Text('Chatter'),
                textfieldcontroller: TextEditingController()
                  ..text = Provider.of<SettingsProvider>(context, listen: false)
                      .topicChatter,
                onChanged: (str) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setTopicChatter(str);
                },
              ),
              SettingsDivider(),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.info),
                ),
                title: Text('O aplikacji'),
                subtitle: Text('Licencje'),
                onTap: () {
                  showAppInfo(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListTileTextField extends StatelessWidget {
  const ListTileTextField({
    Key key,
    @required this.onChanged,
    @required this.textfieldcontroller,
    @required this.icon,
    @required this.title,
  });

  final Function onChanged;
  final TextEditingController textfieldcontroller;
  final Icon icon;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
        title: title,
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2),
          child: TextField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                isDense: true),
            controller: textfieldcontroller,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 10,
      thickness: 2,
    );
  }
}

void showAppInfo(BuildContext context) {
  return showAboutDialog(
    applicationLegalese: ' ',
    context: context,
    applicationName: "TutiCenter",
    applicationVersion: "0.9.9",
    applicationIcon: Icon(
      MdiIcons.rhombusSplit,
      color: Colors.amber,
    ),
    children: [
      Text(
        "Hello there!\n" "May the force be with you",
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(fontStyle: FontStyle.italic),
      ),
      Text(
        "\nPawel Franitza 2020",
        style: Theme.of(context).textTheme.subtitle2,
      ),
    ],
  );
}
