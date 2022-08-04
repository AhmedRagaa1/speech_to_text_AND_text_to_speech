import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class textToSpeech extends StatefulWidget {
  @override
  State<textToSpeech> createState() => _textToSpeechState();
}

class _textToSpeechState extends State<textToSpeech>
{
  final String defaultLanguage = 'en-US';
  TextToSpeech tts = TextToSpeech();
  String text = '';
  double volume = 1;
  double rate = 1.0;
  double pitch = 1.0;
  String language;
  String languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String voice;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = text;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
  }
  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String> displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode);

    /// get voice
    voice = await getVoiceByLang(languageCode);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String> getVoiceByLang(String lang) async {
    final List<String> voices = await tts.getVoiceByLang(languageCode);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'text to voice  ',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: 'Enter your text here...',
                  ),
                  onChanged: (val) {
                    setState(() {
                      text = val;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Volume',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        value: volume,
                        onChanged: (a) {
                          setState(() {
                            volume = a;
                          });
                        },
                        min: 0,
                        max: 2,
                      ),
                    ),
                    Text(
                      '\(${volume.toStringAsFixed(1)}\)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Text(
                      'Rate',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        value: rate,
                        onChanged: (a) {
                          setState(() {
                            rate = a;
                          });
                        },
                        min: 0,
                        max: 2,
                      ),
                    ),
                    Text(
                      '\(${rate.toStringAsFixed(1)}\)',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Text(
                      'Pitch',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        value: pitch,
                        onChanged: (a) {
                          setState(() {
                            pitch = a;
                          });
                        },
                        min: 0,
                        max: 2,
                      ),
                    ),
                    Text(
                      '\(${pitch.toStringAsFixed(1)}\)',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Text(
                      'Language',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 15,),
                    DropdownButton<String>(
                      value: language,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) async {
                        languageCode =
                        await tts.getLanguageCodeByName(newValue);
                        voice = await getVoiceByLang(languageCode);
                        setState(() {
                          language = newValue;
                        });
                      },
                      items: languages
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      ElevatedButton(
                          onPressed: speak,
                          child: Text(
                            'Speak',
                          ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                          onPressed: ()
                          {
                            tts.stop();
                          },
                          child: Text(
                            'Stop',
                          ),
                      ),
                    ],
                  ),
                ),



                  ],
                ),
            ),
          ),
        ),
    );
  }

  void speak() {
    tts.setVolume(volume);
    tts.setRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode);
    }
    tts.setPitch(pitch);
    tts.speak(text);
  }
}
