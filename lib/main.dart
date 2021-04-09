//==============================================================================
//    main.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'padscreen.dart';
import 'settings.dart';

//==============================================================================

// Global preferences object.
SharedPreferences preferences;

// Key used in preferences to store/retrieve path of the last used project.
const String lastFileKey = "lastProject";

// Key used in preferences to store/retrieve font size to use in pads.
const String fontSizeKey = "fontSize";

//==============================================================================

// Application entry point.
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  var settings = await loadSettings();

  runApp(MaterialApp(
    title: 'Open Sampler',
    theme: ThemeData(
      primaryColor: Colors.blueGrey,
    ),
    darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
    ),
    home: PadScreen(settings),
  ));
}

//==============================================================================

Future<Settings> loadSettings() async {

  String last = preferences.getString(lastFileKey);

  if (last != null && last.isNotEmpty) {
    File settingsFile = File(last);

    bool exists = await settingsFile.exists();

    if (exists) {
      try {
        // Read the file.
        String json = await settingsFile.readAsString();
        return new Settings.fromJson(json);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  return defaultSettings;
}

//==============================================================================
