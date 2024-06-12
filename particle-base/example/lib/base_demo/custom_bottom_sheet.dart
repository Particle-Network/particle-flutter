import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<String> options;
  final Function(int) onSelect;

  const CustomBottomSheet({super.key, required this.options, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(options.length, (index) {
        return ListTile(
          leading: const Icon(Icons.check),
          title: Text(options[index]),
          onTap: () {
            Navigator.pop(context);
            onSelect(index); // Callback with the selected index
          },
        );
      }),
    );
  }
}
