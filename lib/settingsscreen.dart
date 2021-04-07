//------------------------------------------------------------------------------
//    settingsscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'settings.dart';

//------------------------------------------------------------------------------

class SettingsScreen extends StatefulWidget {

  final Settings _settings;

  SettingsScreen(this._settings);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(_settings);
}

//------------------------------------------------------------------------------

class _SettingsScreenState extends State<SettingsScreen> {

  Settings _settings;

  _SettingsScreenState(this._settings);

  String fontValue = 'Default';
  int xAmount = 2;
  int yAmount = 3;

  @override
  Widget build(BuildContext context)
  {
    xAmount = _settings.x;
    yAmount = _settings.y;

    return Scaffold(

      appBar: AppBar(
        title: Text("Settings"),
      ),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  // <Widget> is the type of items in the list.
                  children: <Widget>[
                    _buildHorizontalAmountCombo(context),
                    _buildVerticalAmountCombo(context),
                    _buildFontCombo(context)
                  ]),
            )));
  }

  Row _buildHorizontalAmountCombo(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Text('Horizontal Pads'),
        Spacer(),
        DropdownButton<int>(
          value: xAmount,
          onChanged: (int newValue) {
            setState(() {
              xAmount = newValue;
              _settings.x = xAmount;
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
        Spacer()
      ],
    );
  }

  Row _buildVerticalAmountCombo(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Text('Vertical Pads'),
        Spacer(),
        DropdownButton<int>(
          value: yAmount,
          onChanged: (int newValue) {
            setState(() {
              yAmount = newValue;
              _settings.y = yAmount;
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
        Spacer()
      ],
    );
  }

  Row _buildFontCombo(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Text('Font Size'),
        Spacer(),
        DropdownButton<String>(
          value: fontValue,
          onChanged: (String newValue) {
            setState(() {
              fontValue = newValue;
            });
          },
          items: <String>[
            'Default',
            '12',
            '24',
            '32',
            '48',
            '64'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Spacer()
      ],
    );
  }

}

//------------------------------------------------------------------------------