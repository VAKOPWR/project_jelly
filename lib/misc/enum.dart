import 'package:flutter/material.dart';

enum TabType {
  list,
  find,
  pending,
}

Map<TabType, List<Widget>> tabTrailingActions = {
  TabType.list: [
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
      },
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
      },
    ),
    IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
      },
    ),
  ],
  TabType.find: [
    IconButton(
      icon: const Icon(Icons.person_add_alt_1),
      onPressed: () {
      },
    ),
  ],
  TabType.pending: [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
      },
    ),
    IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
      },
    ),
  ],
};
