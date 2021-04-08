//------------------------------------------------------------------------------
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'load.dart';
import 'settingsscreen.dart';
import 'settings.dart';

//------------------------------------------------------------------------------

enum PopupState { NewProject, SaveProject, OpenProject, Settings }

//------------------------------------------------------------------------------

class PadScreen extends StatefulWidget {

  final Settings _settings;

  PadScreen(this._settings);

  @override
  _PadScreenState createState() => _PadScreenState(_settings);
}

//------------------------------------------------------------------------------

class _PadScreenState extends State<PadScreen> {

  Settings _settings;

  _PadScreenState(this._settings);

  void _press()
  {
    // TODO
    // Play sample
  }

  void _longPress()
  {
    // TODO
    // Choose sample
    // Set color
    // Set text.
  }

  List<MaterialButton> _addButtons(int amount)
  {
    List<MaterialButton> list = [];

    for (int i = 0; i < amount; i++)
      list.add(MaterialButton(
          onPressed: _press,
          onLongPress: _longPress,
          enableFeedback: false,
          color: _settings.colors[i],
          child: Text(_settings.names[i])));

    return list;
  }

  void _goToSettings(BuildContext context) async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(_settings)));

    _settings.validate();

    setState(() {});
  }

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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("last", newFile.absolute.path);
    }
  }

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
      _settings = new Settings(json);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;
    double spacing = 4;

    double padWidth = (screenWidth - spacing) / _settings.x;

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
            childAspectRatio: 1.0,        // TODO Make sure we can fit the buttons on the screen, calculate area height and adjust this value.
            padding: EdgeInsets.all(spacing),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            children: _addButtons(_settings.x * _settings.y)),
    ));

  }
}

//------------------------------------------------------------------------------