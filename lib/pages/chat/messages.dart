import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/chat/tabs/chat_friends_tab.dart';
import 'package:project_jelly/pages/chat/tabs/chat_groups_tab.dart';
import 'package:project_jelly/pages/chat/tabs/create_chat_group.dart';

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
              title: Text('Messages'),
              centerTitle: true,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Get.to(() => CreateGroupChat());
                  },
                ),
              ],
            ),
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
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
