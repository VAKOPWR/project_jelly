import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Widget content;
  final ValueChanged<String>? onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.content,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              hintText: "Search",
              filled: true,
              fillColor: Theme.of(context).dialogBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}
