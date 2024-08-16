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
          title: Center(
            child: Text(options[index]),
          ),
          onTap: () {
            onSelect(index); 
          },
        );
      }),
    );
  }
}
