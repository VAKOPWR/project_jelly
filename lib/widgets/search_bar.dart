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
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6)),
                  hintText: "Search",
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
                ),
              ),
            ),
            Expanded(child: content),
          ],
        ));
  }
}
