import 'dart:convert';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:soundpool/soundpool.dart';

//Recording and playing sounds
class AudioProvider extends ChangeNotifier {
  final bubbleMessagePool = Soundpool();

  //Split into play/pause/stop?
  Future<void> playBubbleUserMessageVoice(String path) async {
    bubbleMessagePool.release();
    final bubbleMessageContent = await File(path).readAsBytes();
    final soundId = await bubbleMessagePool.loadUint8List(bubbleMessageContent);
    bubbleMessagePool.play(soundId);
  }

  Future<void> playBubbleBotMessageVoice(String audio) async {
    bubbleMessagePool.release();
    final soundId = await bubbleMessagePool.loadUint8List(base64Decode(audio));
    bubbleMessagePool.play(soundId);
  }

  //Updating recordID everytime new record is created
  Future<String> getRecordingPath() async {
    var directory = await getTemporaryDirectory();
    return directory.path + '/recordings/' + Uuid().v1();
  }

  bool _hasPermission = true;
  bool get hasPermission => _hasPermission;
  Future<bool> _checkPermission() async {
    _hasPermission = await AudioRecorder.hasPermissions;
    return _hasPermission;
  }

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Future<void> start() async {
    if (!await _checkPermission()) return;

    var path = await getRecordingPath();
    print(path);
    print("started!!!!!!!!");
    await AudioRecorder.start(
        path: path, audioOutputFormat: AudioOutputFormat.WAV);
    _isRecording = await AudioRecorder.isRecording;
    notifyListeners();
  }

  Future<Recording> stop() async {
    var recorrding = await AudioRecorder.stop();
    _isRecording = await AudioRecorder.isRecording;
    notifyListeners();

    return recorrding;
  }
}
