//==============================================================================
//    settingsscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:flutter/material.dart';
import 'main.dart';
import 'settings.dart';

//==============================================================================

class SettingsScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final Settings _settings;

  //----------------------------------------------------------------------------

  SettingsScreen(this._settings);

  //----------------------------------------------------------------------------

  @override
  _SettingsScreenState createState() => _SettingsScreenState(_settings);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _SettingsScreenState extends State<SettingsScreen> {

  //----------------------------------------------------------------------------

  Settings _settings;

  _SettingsScreenState(this._settings);

  String fontValue = 'Default';
  int xAmount = 2;
  int yAmount = 3;

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context)
  {
    final TextStyle defaultTextStyle = TextStyle(fontSize: 20);

    xAmount = _settings.x;
    yAmount = _settings.y;

    return Scaffold(

      appBar: AppBar(
        title: Text("Settings"),
      ),
        body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  // <Widget> is the type of items in the list.
                  children: <Widget>[
                    Spacer(),
                    Row(children: <Widget>[Text("Project Settings:", style: defaultTextStyle), Spacer()]),
                    _buildHorizontalAmountCombo(context),
                    _buildVerticalAmountCombo(context),
                    Spacer(),
                    Row(children: <Widget>[Text("Global Settings:", style: defaultTextStyle), Spacer()]),
                    _buildFontCombo(context),
                    Spacer(),
                  ]),
            )));
  }

  //----------------------------------------------------------------------------

  Row _buildHorizontalAmountCombo(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Horizontal Pads'),
        Spacer(),
        DropdownButton<int>(
          value: xAmount,
          onChanged: (int newValue) {
            setState(() {
              xAmount = newValue;
              _settings.x = xAmount;
              _settings.save();
            });
          },
          items: <int>[
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
          ].map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text("$value"),
            );
          }).toList(),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------

  Row _buildVerticalAmountCombo(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Vertical Pads'),
        Spacer(),
        DropdownButton<int>(
          value: yAmount,
          onChanged: (int newValue) {
            setState(() {
              yAmount = newValue;
              _settings.y = yAmount;
              _settings.save();
            });
          },
          items: <int>[
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
          ].map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text("$value"),
            );
          }).toList(),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------

  Row _buildFontCombo(BuildContext context)
  {
    // TODO This might be better if it used an enum.

    String prefFont = preferences.getString(fontSizeKey);

    if (prefFont == null || prefFont.isEmpty)
      prefFont = "Default";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Font Size'),
        Spacer(),
        DropdownButton<String>(
          value: prefFont,
          onChanged: (String newValue) {
            setState(() {
              fontValue = newValue;
              preferences.setString(fontSizeKey, newValue);
            });
          },
          items: <String>[
            'Default',
            '12',
            '18',
            '24',
            '32',
            '40',
            '48',
            '56',
            '64'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

//----------------------------------------------------------------------------

}

//==============================================================================