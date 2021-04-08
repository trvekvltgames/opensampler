//------------------------------------------------------------------------------
//    main.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'padscreen.dart';
import 'settings.dart';

//------------------------------------------------------------------------------

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  var settings = await loadSettings();

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: PadScreen(settings),
  ));
}

Future<Settings> loadSettings() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String last = prefs.getString("last");

  print("last: $last");

  if (last != null && last.isNotEmpty) {
    File settingsFile = File(last);

    bool exists = await settingsFile.exists();

    if (exists) {
      try {
        // Read the file.
        String json = await settingsFile.readAsString();
        return new Settings(json);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  return defaultSettings;
}

//------------------------------------------------------------------------------
