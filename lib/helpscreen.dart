//==============================================================================
//    helpscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:flutter/material.dart';

//==============================================================================

class HelpScreen extends StatelessWidget {

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
            title: Text("Help")
        ),
        body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
                child: ListView(
                    children: <Widget>[
                      Text("Playing Sounds", style: TextStyle(fontSize: 24)),
                      Divider(),
                      Text("Press the pad to trigger its sound."),
                      SizedBox(height: 10),
                      Text("The app doesn't come with built in sound samples, so you need to load your own."),
                      SizedBox(height: 20),
                      Row(children: <Widget> [
                          Icon(Icons.volume_off_rounded),
                          Spacer()]),
                      Divider(),
                      Text("Pressing this icon will stop all sounds immediatelly."),
                      SizedBox(height: 20),
                      Text("Configuring Pads", style: TextStyle(fontSize: 24)),
                      Divider(),
                      Text("Long press the pad to open the pad settings screen."),
                      SizedBox(height: 10),
                      Text("Long sound", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text("Some long sound clips might need special behaviour on some devices. If your long sound clip doesn't play correctly mark it as long."),
                      SizedBox(height: 10),
                      Text("Pad behaviour", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text("Defines how the pad will behave when pressed, while a sound is already playing."),
                    ]
                )
            )
        )
    );
  }

//----------------------------------------------------------------------------
}

//==============================================================================