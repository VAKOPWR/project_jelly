import 'package:flutter/material.dart';
import 'package:project_jelly/pages/chat/tabs/chat_friends_tab.dart';
import 'package:project_jelly/pages/chat/tabs/chat_groups_tab.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

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
              color: Theme.of(context).colorScheme.background,
              child: const Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: 'Friends',
                      ),
                      Tab(
                        text: 'Groups',
                      )
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [ChatFriendsTab(), ChatGroupsTab()],
                  ))
                ],
              ),
            )));
  }
}
