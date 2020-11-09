import 'package:chatapp/providers/SettingsProvider.dart';
import 'package:chatapp/widgets/ShadowLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 50
                  : 40,
          leading: IconButton(
            onPressed: () {
              Provider.of<SettingsProvider>(context, listen: false).savePrefs();
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          title: Text("Ustawienia"),
        ),
        body: Stack(children: <Widget>[
          Theme(
            data: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).copyWith(primaryColor: Colors.blue[400])
                : Theme.of(context),
            child: ListView(
              physics: Provider.of<SettingsProvider>(context, listen: false)
                      .limitAnimations
                  ? null
                  : BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: [
                SettingsCategory(
                  icon: Icon(Icons.settings_applications),
                  label: "Ustawienia aplikacji",
                  description: "Ogólne ustawienia i akcesyjność",
                  settingItemList: [
                    Divider(thickness: 1),
                    Consumer<SettingsProvider>(
                      builder: (ctx, provider, child) => InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          provider.setTheme(ThemeMode.light);
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(context).accentColor,
                              value: ThemeMode.light,
                              groupValue: provider.appTheme,
                              onChanged: (value) {
                                provider.setTheme(value);
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text("Jasny motyw"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<SettingsProvider>(
                      builder: (ctx, provider, child) => InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          provider.setTheme(ThemeMode.dark);
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(context).accentColor,
                              value: ThemeMode.dark,
                              groupValue: provider.appTheme,
                              onChanged: (value) {
                                provider.setTheme(value);
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text("Ciemny motyw"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<SettingsProvider>(
                      builder: (ctx, provider, child) => InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          provider.setTheme(ThemeMode.system);
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(context).accentColor,
                              value: ThemeMode.system,
                              groupValue: provider.appTheme,
                              onChanged: (value) {
                                provider.setTheme(value);
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text("Systemowy motyw"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<SettingsProvider>(
                      builder: (ctx, provider, child) => InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          provider
                              .setLimitAnimations(!provider.limitAnimations);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 46.0),
                              child: Text("Ogranicz animacje"),
                            ),
                            Spacer(),
                            Switch(
                              activeColor: Theme.of(context).accentColor,
                              value: provider.limitAnimations,
                              onChanged: (bool value) {
                                provider.setLimitAnimations(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<SettingsProvider>(
                      builder: (ctx, provider, child) => InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          provider
                              .setLimitAnimations(!provider.limitAnimations);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 46),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    Text("Podpisy pod przyciskami nawigacji"),
                              ),
                              Spacer(),
                              Switch(
                                activeColor: Theme.of(context).accentColor,
                                value: provider.showNavigationBarLabels,
                                onChanged: (bool value) {
                                  provider.setShowNavigationBarLabels(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                SettingsCategory(
                  icon: Icon(Icons.blur_linear),
                  label: "Konfiguracja ROS",
                  description:
                      "Konfiguracja sieciowa ROS, należy wprowadzić adres urządzenia roscore i adres ip aktualnego urządzenia",
                  settingItemList: [
                    Divider(thickness: 1),
                    //Underheader item names
                    SettingsItemField(
                      icon: Icon(MdiIcons.server),
                      label: "Główny serwer (IP)",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .ipAdressMainServer,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setIpAdressMainServer(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.devices),
                      label: "To urządzenie (IP)",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .ipAdressDevice,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setIpAdressDevice(str);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                SettingsCategory(
                  icon: Icon(Icons.chat),
                  label: "Zarządzanie tematami",
                  description:
                      "Wprowadzenie pełnej nazwy tematu pozwala na odbiór i publikacje danych do ROS. Aktualne dane tematów mogą ulec zmianie",
                  settingItemList: [
                    Divider(thickness: 1),

                    //Underheader item names
                    SettingsItemField(
                      icon: Icon(MdiIcons.cube),
                      label: "Odometria robota",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicOdometry,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicOdometry(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.camera),
                      label: "Kamera",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicCamera,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicCamera(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.battery),
                      label: "Bateria",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicBattery,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicBattery(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.speedometer),
                      label: "Prędkość liniowa / kątowa silników",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicVelocity,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicVelocity(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.earthBox),
                      label: "Mapa",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicMap,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicMap(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.navigation),
                      label: "Nawigacja / Cel",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicNavigation,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicNavigation(str);
                      },
                    ),
                    SettingsItemField(
                      icon: Icon(MdiIcons.chat),
                      label: "Chatter",
                      textfieldcontroller: TextEditingController()
                        ..text = Provider.of<SettingsProvider>(context,
                                listen: false)
                            .topicChatter,
                      onChanged: (str) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setTopicChatter(str);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                // SettingsCategory(
                //   icon: Icon(MdiIcons.earth),
                //   label: "Dostęp do treści przez sieć",
                //   description:
                //       "Jeżeli urządzenie udostępnia obrazy stumieniowo; mogą być one wyświetlane jako alternatywa do subskrybcji tematów",
                //   settingItemList: [
                //     Divider(thickness: 1),
                //     //Underheader item names
                //     SettingsItemField(
                //       icon: Icon(MdiIcons.camera),
                //       label: "Adres serwera kamery",
                //       textfieldcontroller: TextEditingController()
                //         ..text = Provider.of<SettingsProvider>(context,
                //                 listen: false)
                //             .webCameraAdress,
                //       onChanged: (str) {
                //         Provider.of<SettingsProvider>(context,
                //                 listen: false)
                //             .setWebCameraAdress(str);
                //       },
                //     ),
                //     SettingsItemField(
                //       icon: Icon(MdiIcons.earthBox),
                //       label: "Adres serwera mapy",
                //       textfieldcontroller: TextEditingController()
                //         ..text = Provider.of<SettingsProvider>(context,
                //                 listen: false)
                //             .webMapAdress,
                //       onChanged: (str) {
                //         Provider.of<SettingsProvider>(context,
                //                 listen: false)
                //             .setWebMapAdress(str);
                //       },
                //     ),
                //   ],
                // ),
                SizedBox(height: 5),
                SettingsCategory(
                  icon: Icon(MdiIcons.information),
                  label: "Informacje",
                  description: "Informacje o aplikacji, licencje",
                  settingItemList: [
                    Divider(thickness: 1),
                    //Underheader item names
                    SettingsInfoButton(
                      icon: Icon(MdiIcons.informationVariant),
                      label: "O aplikacji",
                    ),
                  ],
                ),
              ],
            ),
          ),
          ShadowLine(),
        ]),
      ),
    );
  }
}

class SettingsItemField extends StatelessWidget {
  SettingsItemField({
    Key key,
    this.onChanged,
    this.textfieldcontroller,
    @required this.icon,
    @required this.label,
  });

  final Function onChanged;
  final TextEditingController textfieldcontroller;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 9, right: 9.0, top: 5),
          //   child: icon,
          // ),
          Expanded(
            child: TextField(
              controller: textfieldcontroller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  labelText: label,
                  contentPadding: const EdgeInsets.all(5),
                  prefixIcon: icon),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsInfoButton extends StatelessWidget {
  SettingsInfoButton({
    Key key,
    this.textfieldcontroller,
    @required this.icon,
    @required this.label,
  });

  final TextEditingController textfieldcontroller;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          showAboutDialog(
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
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 30),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11.0),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCategory extends StatelessWidget {
  SettingsCategory({
    Key key,
    this.description = "",
    @required this.icon,
    @required this.label,
    @required this.settingItemList,
  });

  final String description;
  final Icon icon;
  final String label;
  final List<Widget> settingItemList;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: icon,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11, bottom: 3),
                    child: Container(
                      child: Text(label,
                          style: Theme.of(context).textTheme.headline6),
                    ),
                  ),
                ],
              ),
            ),
            description.isEmpty
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 46.0),
                    child: Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: settingItemList,
            ),
          ],
        ),
      ),
    );
  }
}
