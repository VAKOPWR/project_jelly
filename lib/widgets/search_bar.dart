import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Widget content;

  const SearchBarWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              hintText: "Search",
              filled: true,
              fillColor: Theme.of(context).dialogBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}
