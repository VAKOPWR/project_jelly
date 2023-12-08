import 'package:flutter/material.dart';
import 'package:project_jelly/pages/chat/tabs/chat_friends_tab.dart';
import 'package:project_jelly/pages/chat/tabs/chat_groups_tab.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

// TODO hide keyboard on tab chnage
class _MessagesPageState extends State<MessagesPage> {
  void getData() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Messages'), centerTitle: true, elevation: 0.0),
            body: Container(
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                          child: Text("Friends",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary))),
                      Tab(
                          child: Text("Groups",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary))),
                    ],
                  ),
                  Expanded(
                      child: Container(
                          color: Theme.of(context).canvasColor,
                          child: TabBarView(
                            children: [ChatFriendsTab(), ChatGroupsTab()],
                          )))
                ],
              ),
            )));
  }
}
