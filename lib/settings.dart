//------------------------------------------------------------------------------
//    settings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';

//------------------------------------------------------------------------------

class Settings
{
  String name;

  int x;
  int y;

  List<String> samples;
  List<String> names;
  List<Color> colors;

  Settings(String name, int x, int y)
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

Settings defaultSettings = new Settings("Open Sampler", 4,4);

//------------------------------------------------------------------------------