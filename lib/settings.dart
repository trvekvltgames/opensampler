//------------------------------------------------------------------------------
//    settings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'dart:convert';

//------------------------------------------------------------------------------

class Settings
{
  String name;

  int x;
  int y;

  List<String> samples;
  List<String> names;
  List<Color> colors;

  Settings.temp(String name, int x, int y)
  {
    this.name = name;
    this.x = x;
    this.y = y;

    samples = []..length = x * y;
    names = []..length = x * y;
    colors = []..length = x * y;

    for (int i = 0 ; i < x * y ; i++)
    {
      samples[i] = "";
      names[i] = "";
      colors[i] = Colors.grey;
    }
  }

  Settings(String json)
  {
    Map<String, dynamic> map = jsonDecode(json);

    name = map['name'];
    x = map['x'];
    y = map['y'];

    samples = List.from(map['samples']);
    names = List.from(map['names']);

    colors = []..length = x * y;

    List<int> colorValues = List.from(map['colors']);

    for (int i = 0 ; i < colorValues.length ; i++)
      colors[i] = Color(colorValues[i]);
  }

  List<dynamic> _encodeColors()
  {
    List<int> list = [];

    for (Color color in colors)
      list.add(color.value);

    return List<dynamic>.from(list.map((x) => x));
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'x': x,
    'y': y,
    'samples': List<dynamic>.from(samples.map((x) => x)),
    'names': List<dynamic>.from(names.map((x) => x)),
    'colors': _encodeColors(),
  };

  String getJson()
  {
    return jsonEncode(this);
  }

  void validate()
  {
    if (x * y > samples.length)
    {
      for (int i = samples.length ; i < x * y ; i++)
      {
        samples.add("");
        names.add("");
        colors.add(Colors.grey);
      }
    }
    else if (x * y < samples.length)
    {
      for (int i = samples.length - 1; i >= x * y ; i--)
      {
        samples.removeAt(i);
        names.removeAt(i);
        colors.removeAt(i);
      }
    }
  }
}

Settings defaultSettings = Settings.temp("Open Sampler", 3,3);

//------------------------------------------------------------------------------