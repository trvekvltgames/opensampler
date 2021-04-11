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
                      Text("Press the pad to trigger the sound."),
                      SizedBox(height: 20),
                      Text("Configuring Pads", style: TextStyle(fontSize: 24)),
                      Divider(),
                      Text("Long press the pad to open the pad settings screen."),
                    ]
                )
            )
        )
    );
  }

//----------------------------------------------------------------------------
}

//==============================================================================