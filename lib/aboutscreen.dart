//==============================================================================
//    aboutscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//==============================================================================

class AboutScreen extends StatelessWidget {

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("About")
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Center(
          child: ListView(
              children: <Widget>[
                Text("Open Sampler", style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Text("Developed by Leszek Szczepański"),
                SizedBox(height: 10),
                Text("Released under EUPL 1.2"),
                SizedBox(height: 10),
                new InkWell(
                    child: new Text('Source @ GitHub', style: TextStyle(color: Colors.blueGrey)),
                    onTap: () => launch('https://github.com/trvekvltgames/opensampler')
                ),
                SizedBox(height: 10),
                new InkWell(
                    child: new Text('Twitter', style: TextStyle(color: Colors.blueGrey)),
                    onTap: () => launch('https://twitter.com/yezu')
                ),
              ]
          )
        )
      )
    );
  }

  //----------------------------------------------------------------------------
}

//==============================================================================