import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

//audiotesting

import 'package:soundpool/soundpool.dart';

extension MapExtensions<K, V> on Map<K, V> {
  Map getMap(K key) {
    var keyFound = this.containsKey(key);
    if (!keyFound) {
      return null;
    }

    var value = this[key];
    if (value is Map) {
      return value;
    }
    return null;
  }

  V getValue(K key) => this[key];
}

class CustomAIResponse extends AIResponse {
  List<Map> suggestions;
  String outputAudio;

  CustomAIResponse({Map body}) : super(body: body) {
    var data = body.getMap('queryResult');
    var richResponse = data
        ?.getMap('webhookPayload')
        ?.getMap('google')
        ?.getMap('richResponse')
        ?.getValue('suggestions');

    suggestions = List<Map>.from(richResponse ?? const []);
    outputAudio = body['outputAudio'];
  }
}

class AudioDialogFlow extends Dialogflow {
  const AudioDialogFlow({@required authGoogle, language = "en"})
      : super(authGoogle: authGoogle, language: language);

  String _getUrl() {
    // return "https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/sessions/${authGoogle.getSessionId}:detectIntent";

    //BETA locations for dialogflow
    return "https://europe-west2-dialogflow.googleapis.com/v2beta1/projects/${authGoogle.getProjectId}/locations/europe-west2/agent/sessions/${authGoogle.getSessionId}:detectIntent";
  }

  Future<CustomAIResponse> detectIntent(String query,
      {bool isAudio = false}) async {
    var body = {};

    if (isAudio) {
      body['queryInput'] = {
        'audioConfig': {
          'audioEncoding': 'AUDIO_ENCODING_LINEAR_16',
          'languageCode': language,
        }
      };
      body['inputAudio'] = query;
    } else {
      body['queryInput'] = {
        'text': {
          'text': query,
          'languageCode': language,
        }
      };
    }

    var response = await authGoogle.post(
      _getUrl(),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
      },
      body: json.encode(body),
    );

    return CustomAIResponse(body: json.decode(response.body));
  }
}

class DialogflowProvider extends ChangeNotifier {
  final Soundpool pool = Soundpool();

  Future<CustomAIResponse> response(inputMessage,
      {bool isAudio = false}) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/dialogflowapi.json").build();
    AudioDialogFlow dialogflow =
        AudioDialogFlow(authGoogle: authGoogle, language: "pl");
    var aiResponse =
        await dialogflow.detectIntent(inputMessage, isAudio: isAudio);
    // print(response.queryResult.allRequiredParamsPresent.toString());
    // print(response.queryResult.parameters);
    // print(response.getListMessage());

    pool.release();
    final soundId =
        await pool.loadUint8List(base64Decode(aiResponse.outputAudio));
    pool.play(soundId);

    return aiResponse;

    // ChatMessage message = new ChatMessage(
    //   text: response.getMessageResponse(),
    //   name: "Bot",
    //   type: false,
    // );
  }
}
