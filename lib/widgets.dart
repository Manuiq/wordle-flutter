import 'package:flutter/material.dart';

enum SelectedColor {
  initial,
  absent,
  present,
  presentWrongPlace,
}

Color getColor(SelectedColor? state) {
  switch (state) {
    case SelectedColor.initial:
      return Colors.grey;
    case SelectedColor.absent:
      return Colors.white30;
    case SelectedColor.present:
      return Colors.green;
    case SelectedColor.presentWrongPlace:
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.buttonColors,
    required this.onEnter,
    required this.onBackspace,
  }) : super(key: key);

  final String _firstRow = "qwertyuiop";
  final String _secondRow = 'asdfghjkl';
  final String _thirdRow = 'zxcvbnm';

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onEnter;

  final Map<String, SelectedColor> buttonColors;

  void _textInputHandler(String text) => onTextInput.call(text);

  void _backspaceHandler() => onBackspace.call();

  void _enterHandler(String text) => onEnter.call();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          for (var i in _firstRow.split(''))
            TextKey(
              color: getColor(buttonColors[i]),
              text: i,
              onTextInput: _textInputHandler,
            )
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 15),
          for (var i in _secondRow.split(''))
            TextKey(
              color: getColor(buttonColors[i]),
              text: i,
              onTextInput: _textInputHandler,
            ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            color: Colors.grey,
            text: 'Enter',
            flex: 2,
            onTextInput: _enterHandler,
          ),
          for (var i in _thirdRow.split(''))
            TextKey(
              color: getColor(buttonColors[i]),
              text: i,
              onTextInput: _textInputHandler,
            ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.text,
    required this.color,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          height: 48,
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: color,
            child: InkWell(
              child: Align(
                alignment: Alignment.center,
                child: Text(text.toUpperCase(), textAlign: TextAlign.center),
              ),
              onTap: () {
                onTextInput(text);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key? key,
    required this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          height: 48,
          child: Center(
            child: InkWell(
              onTap: onBackspace,
              child: const Icon(Icons.backspace),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
