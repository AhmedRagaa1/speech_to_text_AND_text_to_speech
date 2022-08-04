

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:speech_app/screens/speech_to_text_screen.dart';
import 'package:speech_app/screens/text_to_speech.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speech',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()
              {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>speechToTextScreen()));
                Get.to(speechToTextScreen());
                print("speech");
              },
              child: Text(
                'speech to text',
              ),
            ),
            ElevatedButton(
              onPressed: ()
              {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>textToSpeech()));
                Get.to(textToSpeech());
                print("text");
              },
              child: Text(
                'text to speech ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
