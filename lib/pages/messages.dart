import 'package:flutter/material.dart';
import 'package:project_jelly/pages/chat/tabs/chat_friends_tab.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void getData() {}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Messages',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          color: Theme.of(context).colorScheme.background,
                          child: TabBarView(
                            controller: _tabController,
                            children: [ChatFriendsTab()],
                          )))
                ],
              ),
            )));
  }
}
