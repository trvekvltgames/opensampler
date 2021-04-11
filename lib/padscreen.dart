//==============================================================================
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'aboutscreen.dart';
import 'helpscreen.dart';
import 'load.dart';
import 'main.dart';
import 'settingsscreen.dart';
import 'padsettings.dart';
import 'settings.dart';
import 'sampleplayer.dart';

//==============================================================================

enum PopupState { NewProject, SaveProject, OpenProject, Settings, Help, About }

//==============================================================================

class PadScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final Settings _settings;
  final SamplePlayer _player = SamplePlayer();

  //----------------------------------------------------------------------------

  PadScreen(this._settings);

  //----------------------------------------------------------------------------

  @override
  _PadScreenState createState() => _PadScreenState(_settings, _player);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _PadScreenState extends State<PadScreen> {

  //----------------------------------------------------------------------------

  Settings _settings;
  SamplePlayer _player;

  //----------------------------------------------------------------------------

  _PadScreenState(Settings settings, SamplePlayer player)
  {
    this._settings = Settings.copy(settings);
    this._player = player;

    _player.init(_settings);
  }

  //----------------------------------------------------------------------------

  void _press(int idx)
  {
    _player.play(idx);
  }

  //----------------------------------------------------------------------------

  void _longPress(BuildContext context, int padIdx, PadSettings settings) async
  {
    int padX = (padIdx / _settings.x).floor();
    int padY = padIdx - (padX * _settings.x);

    await Navigator.push(context, MaterialPageRoute(builder: (context) => PadSettingsScreen(padX, padY, _settings.padSettings[padIdx])));

    _settings.validate();

    _player.init(_settings);
    _settings.save();

    setState(() {});
  }

  //----------------------------------------------------------------------------

  List<MaterialButton> _addButtons(BuildContext context, int amount)
  {
    List<MaterialButton> list = [];

    double fontSize;

    String prefFont = preferences.getString(fontSizeKey);

    if (prefFont != null && prefFont.isNotEmpty && prefFont != "Default")
      fontSize = double.parse(prefFont);

    for (int i = 0; i < amount; i++) {

      TextStyle buttonTextStyle;

      if (fontSize != null)
        buttonTextStyle = TextStyle(color: _settings.padSettings[i].textColor, fontSize: fontSize);
      else
        buttonTextStyle = TextStyle(color: _settings.padSettings[i].textColor);

      list.add(MaterialButton(
          onPressed: () {_press(i); },
          onLongPress: () {
            _longPress(context, i, _settings.padSettings[i]);
          },
          enableFeedback: false,
          color: _settings.padSettings[i].color,
          child: Text(_settings.padSettings[i].caption,
            style: buttonTextStyle)));
    }

    return list;
  }

  //----------------------------------------------------------------------------

  void _goToNew(BuildContext context) async
  {
    var ok = await confirm(context, content: Text('This will close current project and create a blank one. Continue?'));

    if (ok) {
      _settings = Settings.copy(defaultSettings);
      _settings.save();

      _player.init(_settings);

      preferences.setString(lastFileKey, _settings.file.absolute.path);
    }

    setState(() {});
  }

  //----------------------------------------------------------------------------

  void _goToSettings(BuildContext context) async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(_settings)));

    _settings.validate();
    _settings.save();

    _player.init(_settings);

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

      String path = documentDirectory.path;
      File newFile = File('$path/$name.json');

      _settings.file = newFile;
      _settings.save();

      _player.init(_settings);

      preferences.setString(lastFileKey, newFile.absolute.path);
    }
  }

  //----------------------------------------------------------------------------

  void _goToOpen(BuildContext context) async
  {
    List<File> files = [];

    await for (var file in documentDirectory.list(recursive: false, followLinks: false)) {
      if (file.path.endsWith(".json") && basename(file.path) != "temp.json")
        files.add(file);
    }

    File settingsFile = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoadScreen(files)));

    if (settingsFile != null) {
      String json = await settingsFile.readAsString();
      _settings = new Settings.fromJson(settingsFile, json);
    }

    _player.init(_settings);

    setState(() {});
  }

  //----------------------------------------------------------------------------

  void _goToHelp(BuildContext context) async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
  }

  //----------------------------------------------------------------------------

  void _goToAbout(BuildContext context) async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
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
      backgroundColor: Color.fromARGB(255, 100, 100, 100),
      appBar: AppBar(
        title: Text(_settings.name),
        actions: [
          IconButton(
              icon: const Icon(Icons.volume_off_rounded),
              onPressed: () { _player.stop(); }),
          PopupMenuButton<PopupState>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupState>>[
                new PopupMenuItem<PopupState>(value: PopupState.NewProject, child: new Text('New Project')),
                new PopupMenuItem<PopupState>(value: PopupState.SaveProject, child: new Text('Save Project')),
                new PopupMenuItem<PopupState>(value: PopupState.OpenProject, child: new Text('Open Project')),
                new PopupMenuItem<PopupState>(value: PopupState.Settings, child: new Text('Settings')),
                new PopupMenuDivider(),
                new PopupMenuItem<PopupState>(value: PopupState.Help, child: new Text('Help')),
                new PopupMenuItem<PopupState>(value: PopupState.About, child: new Text('About')),
              ],

              // TODO Add credits/about and help.

              onSelected: (PopupState state) {
                switch(state)
                {
                  case PopupState.NewProject:
                    _goToNew(context);
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

                  case PopupState.Help:
                    _goToHelp(context);
                    break;

                  case PopupState.About:
                    _goToAbout(context);
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
            children: _addButtons(context, _settings.x * _settings.y)),
    ));
  }

  //----------------------------------------------------------------------------
}

//==============================================================================