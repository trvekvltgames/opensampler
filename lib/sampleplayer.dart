//==============================================================================
//    padsettings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:audioplayers/audioplayers.dart';

import 'settings.dart';

//==============================================================================

class SamplePlayer {

  //----------------------------------------------------------------------------

  List<AudioPlayer> _players = [];
  Settings _settings;

  //----------------------------------------------------------------------------

  void init(Settings settings) {

    _settings = settings;

    for (AudioPlayer player in _players) {
      if (player != null)
        player.release();
    }

    _players.clear();

    for (PadSettings pad in settings.padSettings) {
      if (pad.sample != null && pad.sample.isNotEmpty) {
        AudioPlayer player = AudioPlayer(mode: pad.long ? PlayerMode.MEDIA_PLAYER : PlayerMode.LOW_LATENCY);

        player.setUrl(pad.sample, isLocal: true);
        player.setReleaseMode(pad.looped ? ReleaseMode.LOOP : ReleaseMode.STOP);
        player.setVolume(pad.volume);

        _players.add(player);
      }
      else {
        _players.add(null);
      }
    }
  }

  //----------------------------------------------------------------------------

  void play(int idx)
  {
    AudioPlayer player = _players[idx];

    if (player != null) {

      if (player.state == AudioPlayerState.PLAYING) {

        switch (_settings.padSettings[idx].behaviour)
        {
          case PressBehaviour.Pause:
            player.pause();
            break;

          case PressBehaviour.Stop:
            player.stop();
            break;

          case PressBehaviour.Restart:
            player.stop();
            player.resume();
            break;
        }

      }
      else {
        player.resume();
      }
    }

  }

  //----------------------------------------------------------------------------

  void stop() {

    for (AudioPlayer player in _players) {
      if (player != null)
        player.stop();
    }

  }

  //----------------------------------------------------------------------------

  void clear()
  {
    _settings = null;
    _players = null;
  }

  //----------------------------------------------------------------------------
}

//==============================================================================