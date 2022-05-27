import 'dart:convert';
import 'dart:developer';
import "dart:math" as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'guide.dart';
import 'widgets.dart';

void main() => runApp(const WordleApp());

//Game conditions

int wordSize = 5; //word is 5 letters only
int maxAttempts = 5; //impacts board size too

class WordleApp extends StatelessWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        }, child:const MaterialApp(home: KeyboardDemo()));
  }
}

SelectedColor getSelectedState(
    List<String> secret, String input, int position) {
  //not enough to compare only current one, if there is several same letters
  // hints are not obvious
  if (secret[position] == input) {
    return SelectedColor.present;
  } else if (secret.contains(input)) {
    return SelectedColor.presentWrongPlace;
  } else {
    return SelectedColor.absent;
  }
}

class KeyboardDemo extends StatefulWidget {
  const KeyboardDemo({Key? key}) : super(key: key);

  @override
  _KeyboardDemoState createState() => _KeyboardDemoState();
}

class _KeyboardDemoState extends State<KeyboardDemo> {
  @override
  void initState() {
    super.initState();
    _readJson();
  }

  int _currentAttempt = 1;

  final List<String> _userInputs =
      List.filled(wordSize * maxAttempts, "", growable: false);
  final List<SelectedColor> _inputsState = List.filled(
      wordSize * maxAttempts, SelectedColor.initial,
      growable: false);
  final Map<String, SelectedColor> _keyboardKeysState = {};

  //dictionary and the keyword part
  late List<String> _dictionary;
  late String _secret;

  Future<void> _readJson() async {
    final String response =
        await rootBundle.loadString('assets/dictionary.json');
    final data = await json.decode(response);
    _dictionary = List<String>.from(data);
    _secret = _dictionary[math.Random().nextInt(_dictionary.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          const Spacer(flex: 1),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    icon: const Text('Guide'),
                    label: const Icon(Icons.help),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuideRoute()),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  IgnorePointer(
                      ignoring: true,
                      child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: wordSize),
                      itemCount: _userInputs.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: Text(_userInputs[index].toUpperCase()),
                          decoration: BoxDecoration(
                              color: getColor(_inputsState[index]),
                              borderRadius: BorderRadius.circular(15)),
                        );
                      })),
                ],
              )),
          const Spacer(flex: 1),
          Expanded(
              flex: 10,
              child: CustomKeyboard(
                buttonColors: _keyboardKeysState,
                onTextInput: (myText) {
                  _insertLetter(myText);
                },
                onEnter: _enter,
                onBackspace: _backspace,
              )),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  void _insertLetter(String letter) {
    int replace = _userInputs.indexWhere((o) => o.isEmpty);
    setState(() {
      if (replace < _currentAttempt * wordSize) {
        _userInputs[replace] = letter;
      }
    });
    log('_insertText: $letter');
    log('secret: $_secret');
  }

  void _enter() {
    var result = _userInputs
        .sublist((_currentAttempt - 1) * wordSize, _currentAttempt * wordSize)
        .join()
        .toLowerCase();
    //validate input
    if (!_dictionary.contains(result)) {
      //validation failed
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No such word in dictionary 😔. Each attempt must be a valid 5-letter word 📝."),
      ));
    } else if (result != _secret) {
      //didn't get the word
      if (_currentAttempt == maxAttempts) {
        //last attempt failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Out of attempts. Game over!"),
        ));
      } else {
        //game goes on, provide visual clues
        setState(() {
          result.split('').forEachIndexed((index, element) {
            _inputsState[(_currentAttempt - 1) * wordSize + index] =
                getSelectedState(_secret.split(''), element, index);
          });
          _currentAttempt++;
          for (var i in result.split('')) {
            if (!_secret.split('').contains(i)) {
              log('highlighting $i item');
              _keyboardKeysState[i] = SelectedColor.absent;
            }
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You won"),
      ));
      log('you won');
    }
  }

  void _backspace() {
    var index = _userInputs.lastIndexWhere((o) => o.isNotEmpty);
    if (index >= (_currentAttempt - 1) * wordSize) {
      setState(() {
        _userInputs[index] = "";
      });
    }
  }
}
