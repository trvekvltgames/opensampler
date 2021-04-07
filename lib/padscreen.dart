//------------------------------------------------------------------------------
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';

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
                    break;

                  case PopupState.OpenProject:
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