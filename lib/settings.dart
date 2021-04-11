//==============================================================================
//    settings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'main.dart';

//==============================================================================

enum PressBehaviour { Stop, Pause, Restart }

//------------------------------------------------------------------------------

String pressBehaviourToString(PressBehaviour mode)
{
  switch (mode)
  {
    case PressBehaviour.Stop:
      return "Stop";

    case PressBehaviour.Pause:
      return "Pause";

    case PressBehaviour.Restart:
      return "Restart";
  }

  return null;
}

//------------------------------------------------------------------------------

PressBehaviour pressBehaviourFromString(String string)
{
  switch (string)
  {
    case "Stop":
      return PressBehaviour.Stop;

    case "Pause":
      return PressBehaviour.Pause;

    case "Restart":
      return PressBehaviour.Restart;
  }

  return PressBehaviour.Restart;
}

//==============================================================================

class PadSettings {

  //----------------------------------------------------------------------------

  String sample;
  String caption;
  Color color;
  Color textColor;
  bool looped;
  bool long;

  PressBehaviour behaviour;

  double volume;

  Settings _settings;

  //----------------------------------------------------------------------------

  PadSettings(Settings settings, int index)
  {
    _settings = settings;

    index++;

    sample = "";
    caption = "$index";

    color = Colors.grey;
    color = color.withOpacity(1.0);

    volume = 1.0;

    textColor = Colors.black;
    textColor = textColor.withOpacity(1.0);

    behaviour = PressBehaviour.Restart;

    looped = false;
    long = false;
  }

  //----------------------------------------------------------------------------

  PadSettings.copy(PadSettings settings)
  {
    this._settings = settings._settings;

    this.sample = settings.sample;
    this.caption = settings.caption;

    this.color = settings.color;
    this.color = this.color.withOpacity(1.0);

    this.textColor = settings.textColor;
    this.textColor = this.textColor.withOpacity(1.0);

    this.looped = settings.looped;
    this.volume = settings.volume;
    this.long = settings.long;

    this.behaviour = settings.behaviour;
  }

  //----------------------------------------------------------------------------

  PadSettings.fromJson(Settings settings, Map<String, dynamic> map)
  {
    _settings = settings;
    sample = map["sample"];
    caption = map["caption"];

    int colorVal = map["color"];
    color = colorVal != null ? Color(colorVal) : Colors.grey;
    color = color.withOpacity(1.0);

    int textColorVal = map["textColor"];
    textColor = textColorVal != null ? Color(textColorVal) : Colors.black;
    textColor = textColor.withOpacity(1.0);

    long = map["long"];
    looped = map["looped"];
    volume = map["volume"];

    behaviour = pressBehaviourFromString(map["behaviour"]);
  }

  //----------------------------------------------------------------------------

  Map<String, dynamic> toJson() =>
  {
    "sample": sample,
    "caption": caption,
    "color": color.value,
    "textColor": textColor.value,
    "looped": looped,
    "volume": volume,
    "long": long,
    "behaviour": pressBehaviourToString(behaviour)
  };

  //----------------------------------------------------------------------------

  void save()
  {
    _settings.save();
  }

  //----------------------------------------------------------------------------
}

//==============================================================================

class Settings {

  //----------------------------------------------------------------------------

  String name;
  File file;

  int x;
  int y;

  List<PadSettings> padSettings;

  //----------------------------------------------------------------------------

  Settings.temp(String name, int x, int y)
  {
    this.name = name;
    this.x = x;
    this.y = y;

    padSettings = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
      padSettings[i] = PadSettings(this, i);

    String path = documentDirectory.path;
    file = File('$path/temp.json');
  }

  //----------------------------------------------------------------------------

  Settings.copy(Settings settings)
  {
    this.name = settings.name;
    this.file = settings.file;
    this.x = settings.x;
    this.y = settings.y;

    this.padSettings = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
      this.padSettings[i] = PadSettings.copy(settings.padSettings[i]);
  }

  //----------------------------------------------------------------------------

  Settings.fromJson(File file, String json)
  {
    this.file = file;

    Map<String, dynamic> map = jsonDecode(json);

    name = map['name'];
    x = map['x'];
    y = map['y'];

    List<Map<String, dynamic>> padMap = List.from(map['padSettings']);

    padSettings = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
      padSettings[i] = PadSettings.fromJson(this, padMap[i]);
  }

  //----------------------------------------------------------------------------

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'x': x,
    'y': y,
    'padSettings': List<dynamic>.from(padSettings.map((x) => x)),
  };

  //----------------------------------------------------------------------------

  String getJson()
  {
    return jsonEncode(this);
  }

  //----------------------------------------------------------------------------

  void save()
  {
    file.writeAsString(getJson());
  }

  //----------------------------------------------------------------------------

  void validate()
  {
    if (x * y > padSettings.length)
    {
      for (int i = padSettings.length ; i < x * y ; i++)
        padSettings.add(PadSettings(this, i));
    }
    else if (x * y < padSettings.length)
    {
      for (int i = padSettings.length - 1; i >= x * y ; i--)
        padSettings.removeAt(i);
    }
  }

  //----------------------------------------------------------------------------
}

//==============================================================================

Settings defaultSettings = Settings.temp("Open Sampler", 3,3);

//==============================================================================