//==============================================================================
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'load.dart';
import 'main.dart';
import 'settingsscreen.dart';
import 'padsettings.dart';
import 'settings.dart';

//==============================================================================

enum PopupState { NewProject, SaveProject, OpenProject, Settings }

//==============================================================================

class PadScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final Settings _settings;

  //----------------------------------------------------------------------------

  PadScreen(this._settings);

  //----------------------------------------------------------------------------

  @override
  _PadScreenState createState() => _PadScreenState(_settings);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _PadScreenState extends State<PadScreen> {

  //----------------------------------------------------------------------------

  Settings _settings;

  //----------------------------------------------------------------------------

  _PadScreenState(Settings settings)
  {
    this._settings = Settings.copy(settings);
  }

  //----------------------------------------------------------------------------

  void _press()
  {
    // TODO
    // Play sample
  }

  //----------------------------------------------------------------------------

  void _longPress(int padIdx, PadSettings settings) async
  {
    int padX = (padIdx / _settings.x).floor();
    int padY = padIdx - (padX * _settings.x);

    await Navigator.push(context, MaterialPageRoute(builder: (context) => PadSettingsScreen(padX, padY, _settings.padSettings[padIdx])));

    _settings.validate();

    setState(() {});
  }

  //----------------------------------------------------------------------------

  List<MaterialButton> _addButtons(int amount)
  {
    List<MaterialButton> list = [];

    for (int i = 0; i < amount; i++)
      list.add(MaterialButton(
          onPressed: _press,
          onLongPress: () {_longPress(i, _settings.padSettings[i]); },
          enableFeedback: false,
          color: _settings.padSettings[i].color,
          child: Text(_settings.padSettings[i].caption)));

    return list;
  }

  //----------------------------------------------------------------------------

  void _goToNew() async
  {
    // TODO All the changes to the project without saving should be saved to a temp project file.
    // TODO Save the current project (named or temp) on exit, so that it's always restored to it's last used state on app start.
    // TODO Save the current project (named, not temp) when loading a new project and loading a saved one. 

    var ok = await confirm(context, content: Text('This will close current project and create a blank one. Continue?'));

    if (ok)
      _settings = Settings.copy(defaultSettings);

    setState(() {});
  }

  //----------------------------------------------------------------------------

  void _goToSettings(BuildContext context) async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(_settings)));

    _settings.validate();

    setState(() {});
  }

  //----------------------------------------------------------------------------

  void _goToSave(BuildContext context) async
  {
    TextEditingController controller = TextEditingController();

    var ok = await confirm(context, title: Text('Input project name'), content: TextField(controller: controller));

    if (ok)
    {
      String name = controller.text;
      _settings.name = name;

      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File newFile = File('$path/$name.json');

      String settingJson = _settings.getJson();
      newFile.writeAsString(settingJson);

      preferences.setString(lastFileKey, newFile.absolute.path);
    }
  }

  //----------------------------------------------------------------------------

  void _goToOpen(BuildContext context) async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    List<File> files = [];

    await for (var file in directory.list(recursive: false, followLinks: false)) {
      if (file.path.endsWith(".json"))
        files.add(file);
    }

    File settingsFile = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoadScreen(files)));

    if (settingsFile != null) {
      String json = await settingsFile.readAsString();
      _settings = new Settings.fromJson(json);
    }

    setState(() {});
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double splitBarHeight = MediaQuery.of(context).viewPadding.bottom;

    double spacing = 4;

    double padWidth = (screenWidth - (spacing * (_settings.x + 1)))  / _settings.x;
    double padHeight = (screenHeight - kToolbarHeight - statusBarHeight - splitBarHeight - (spacing * (_settings.y + 1))) / _settings.y;

    double ratio = padWidth / padHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text(_settings.name),
        actions: [
          PopupMenuButton<PopupState>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<PopupState>>[
                new PopupMenuItem<PopupState>(value: PopupState.NewProject, child: new Text('New Project')),
                new PopupMenuItem<PopupState>(value: PopupState.SaveProject, child: new Text('Save Project')),
                new PopupMenuItem<PopupState>(value: PopupState.OpenProject, child: new Text('Open Project')),
                new PopupMenuItem<PopupState>(value: PopupState.Settings, child: new Text('Settings')),
              ],

              onSelected: (PopupState state) {
                switch(state)
                {
                  case PopupState.NewProject:
                    _goToNew();
                    break;

                  case PopupState.SaveProject:
                    _goToSave(context);
                    break;

                  case PopupState.OpenProject:
                    _goToOpen(context);
                    break;

                  case PopupState.Settings:
                    _goToSettings(context);
                    break;
                }
              })
        ],
      ),

      body: Center(
        child: GridView.extent(
            maxCrossAxisExtent: padWidth,
            childAspectRatio: ratio,
            padding: EdgeInsets.only(left: spacing, right: spacing, top: spacing),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            children: _addButtons(_settings.x * _settings.y)),
    ));
  }

  //----------------------------------------------------------------------------
}

//==============================================================================