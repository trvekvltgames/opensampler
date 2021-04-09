//==============================================================================
//    padsettings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:opensampler/settings.dart';
import 'package:path/path.dart';

//==============================================================================

class PadSettingsScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final int _padX;
  final int _padY;
  final PadSettings _settings;

  //----------------------------------------------------------------------------

  PadSettingsScreen(this._padX, this._padY, this._settings);

  //----------------------------------------------------------------------------

  @override
  _PadSettingsScreenState createState() => _PadSettingsScreenState(_padX, _padY, _settings);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _PadSettingsScreenState extends State<PadSettingsScreen> {

  //----------------------------------------------------------------------------

  final int _padX;
  final int _padY;
  final PadSettings _settings;

  //----------------------------------------------------------------------------

  _PadSettingsScreenState(this._padX, this._padY, this._settings);

  //----------------------------------------------------------------------------

  void _onSelectSample() async
  {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if(result != null)
      _settings.sample = result.files.single.path;

    setState(() {});
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    // TODO
    // Choose sample
    // Set color
    // Set text.

    String sampleName = _settings.sample.isNotEmpty ? basename(_settings.sample) : "";

    return Scaffold(

        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // <Widget> is the type of items in the list.
                  children: <Widget>[
                    Spacer(),
                    Text("Sound Clip:"),
                    Row(
                      children: <Widget>[
                        Text(sampleName),
                        Spacer(),
                        TextButton(onPressed: _onSelectSample, child: Text("Select"))
                      ],
                    ),
                    Text("Color:"),
                    Text("Caption:"),
                    Text("Play Mode:"),
                    Spacer(),
                  ]),
            )));
  }

  //----------------------------------------------------------------------------
}

//==============================================================================