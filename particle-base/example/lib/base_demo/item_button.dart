import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const ItemButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            )),
      ),
    );
  }
}

class MethodItem {
  String text;
  VoidCallback onPressed;

  MethodItem(this.text, this.onPressed);
}
