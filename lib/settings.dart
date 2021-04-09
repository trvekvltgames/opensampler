//==============================================================================
//    settings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:flutter/material.dart';
import 'dart:convert';

//==============================================================================

enum PlayMode { Normal, Looped, Hold }

//------------------------------------------------------------------------------

String _playModeToString(PlayMode mode)
{
  switch (mode)
  {
    case PlayMode.Normal:
      return "Normal";

    case PlayMode.Looped:
      return "Looped";

    case PlayMode.Hold:
      return "Hold";
  }

  return null;
}

//------------------------------------------------------------------------------

PlayMode _playModeFromString(String string)
{
  switch (string)
  {
    case "Normal":
      return PlayMode.Normal;

    case "Looped":
      return PlayMode.Looped;

    case "Hold":
      return PlayMode.Hold;
  }

  return null;
}

//==============================================================================

class PadSettings {

  //----------------------------------------------------------------------------

  String sample;
  String caption;
  Color color;
  PlayMode mode;

  //----------------------------------------------------------------------------

  PadSettings(int index)
  {
    index++;

    sample = "";
    caption = "$index";
    color = Colors.black12;
    mode = PlayMode.Normal;;
  }

  //----------------------------------------------------------------------------

  PadSettings.copy(PadSettings settings)
  {
    this.sample = settings.sample;
    this.caption = settings.caption;
    this.color = settings.color;
    this.mode = settings.mode;
  }

  //----------------------------------------------------------------------------

  PadSettings.fromJson(Map<String, dynamic> map)
  {
    sample = map["sample"];
    caption = map["caption"];

    int colorVal = map["color"];
    color = Color(colorVal);

    mode = _playModeFromString(map["mode"]);
  }

  //----------------------------------------------------------------------------

  Map<String, dynamic> toJson() =>
  {
    "sample": sample,
    "caption": caption,
    "color": color.value,
    "mode": _playModeToString(mode),
  };

  //----------------------------------------------------------------------------
}

//==============================================================================

class Settings {

  //----------------------------------------------------------------------------

  String name;

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
      padSettings[i] = PadSettings(i);
  }

  //----------------------------------------------------------------------------

  Settings.copy(Settings settings)
  {
    this.name = settings.name;
    this.x = settings.x;
    this.y = settings.y;

    this.padSettings = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
      this.padSettings[i] = PadSettings.copy(settings.padSettings[i]);
  }

  //----------------------------------------------------------------------------

  Settings.fromJson(String json)
  {
    Map<String, dynamic> map = jsonDecode(json);

    name = map['name'];
    x = map['x'];
    y = map['y'];

    List<Map<String, dynamic>> padMap = List.from(map['padSettings']);

    padSettings = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
      padSettings[i] = PadSettings.fromJson(padMap[i]);
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

  void validate()
  {
    if (x * y > padSettings.length)
    {
      for (int i = padSettings.length ; i < x * y ; i++)
        padSettings.add(PadSettings(i));
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