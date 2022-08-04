import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class speechToTextScreen extends StatefulWidget {




  @override
  State<speechToTextScreen> createState() => _speechToTextScreenState();
}

class _speechToTextScreenState extends State<speechToTextScreen>
{
  final Map<String , HighlightedWord> _highlights=
  {
    "flutter":HighlightedWord(
      onTap: (){},
      textStyle: TextStyle(
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    ),
    "ahmed":HighlightedWord(
      onTap: ()=> print('Ahmed'),
      textStyle: TextStyle(
        color: Colors.lightGreen,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    ),
    "developer":HighlightedWord(
      onTap: (){},
      textStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    ),
  };
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'press';
  double _confidence = 1.0 ;



  @override
  void initState() {

    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'voice to text',
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: _isListening ? Colors.red : Colors.white,
        endRadius: 78,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,

        child: FloatingActionButton(
          onPressed: _Listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 50,
            ),


          ),
        ),
      ),
    );
  }

  void _Listen() async
  {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
