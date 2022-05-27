import 'package:flutter/material.dart';

import 'widgets.dart';

class GuideRoute extends StatelessWidget {
  const GuideRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
      ),
      backgroundColor: Colors.black87,
      body: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              '''WORDLY is about guessing the hidden word in 6 tries.

Each guess must be a valid 5 letter word. Hit the enter button to submit.

After each guess, the color of the tiles will change to show how close your guess was to the word.''',
              style: TextStyle(color: Colors.white54),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(200, 20, 200, 4),
            child: Row(children: [
              const SizedBox(width: 15),
              for (var i in "weary".split(''))
                TextKey(
                  color: getColor((i == "w") ? SelectedColor.present : SelectedColor.initial),
                  text: i,
                  onTextInput: (myText) {},
                ),
              const SizedBox(width: 15),
            ])),
        const Text('The letter W is in the word and in the correct spot.',
            style: TextStyle(color: Colors.white54)),
        Padding(
            padding: const EdgeInsets.fromLTRB(200, 20, 200, 4),
            child: Row(children: [
              const SizedBox(width: 15),
              for (var i in "pills".split(''))
                TextKey(
                  color: getColor((i == "i") ? SelectedColor.presentWrongPlace : SelectedColor.initial),
                  text: i,
                  onTextInput: (myText) {},
                ),
              const SizedBox(width: 15),
            ])),
        const Text('The letter I is in the word but in the wrong spot.',
            style: TextStyle(color: Colors.white54)),
        Padding(
            padding: const EdgeInsets.fromLTRB(200, 20, 200, 4),
            child: Row(children: [
              const SizedBox(width: 15),
              for (var i in "vague".split(''))
                TextKey(
                  color: getColor((i == "u") ? SelectedColor.absent : SelectedColor.initial),
                  text: i,
                  onTextInput: (myText) {},
                ),
              const SizedBox(width: 15),
            ])),
        const Text('The letter U is not in the word in any spot.',
            style: TextStyle(color: Colors.white54)),
      ]),
    );
  }
}
