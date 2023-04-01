import 'dart:ffi';

import 'package:flutter/material.dart';

import 'widgets.dart';

class GuideRoute extends StatelessWidget {
  final bool isTv;

  const GuideRoute({Key? key, required this.isTv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingHorizontal = isTv ? 200 : 20;
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
      ),
      backgroundColor: Colors.black87,
      body: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              '''WORDLY is about guessing the hidden word in 5 tries.

Each guess must be a valid 5 letter word. Hit the enter button to submit.

After each guess, the color of the tiles will change to show how close your guess was to the word.''',
              style: TextStyle(color: Colors.white54),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(
                paddingHorizontal, 20, paddingHorizontal, 4),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(children: [
                  const SizedBox(width: 15),
                  for (var i in "weary".split(''))
                    TextKey(
                      color: getColor(
                          (i == "w")
                              ? SelectedColor.present
                              : SelectedColor.initial,
                          false),
                      text: i,
                      onTextInput: (myText) {},
                    ),
                  const SizedBox(width: 15),
                ]))),
        const Text('The letter W is in the word and in the correct spot.',
            style: TextStyle(color: Colors.white54)),
        Padding(
            padding: EdgeInsets.fromLTRB(
                paddingHorizontal, 20, paddingHorizontal, 4),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(children: [
                  const SizedBox(width: 15),
                  for (var i in "pills".split(''))
                    TextKey(
                      color: getColor(
                          (i == "i")
                              ? SelectedColor.presentWrongPlace
                              : SelectedColor.initial,
                          false),
                      text: i,
                      onTextInput: (myText) {},
                    ),
                  const SizedBox(width: 15),
                ]))),
        const Text('The letter I is in the word but in the wrong spot.',
            style: TextStyle(color: Colors.white54)),
        Padding(
            padding: EdgeInsets.fromLTRB(
                paddingHorizontal, 20, paddingHorizontal, 4),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(children: [
                  const SizedBox(width: 15),
                  for (var i in "vague".split(''))
                    TextKey(
                      color: getColor(
                          (i == "u")
                              ? SelectedColor.absent
                              : SelectedColor.initial,
                          false),
                      text: i,
                      onTextInput: (myText) {},
                    ),
                  const SizedBox(width: 15),
                ]))),
        const Text('The letter U is not in the word in any spot.',
            style: TextStyle(color: Colors.white54)),
      ]),
    );
  }
}
