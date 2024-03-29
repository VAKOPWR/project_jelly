import 'package:flutter/material.dart';
import 'package:project_jelly/pages/ghost_mode/tabs/ghost_mode_tab_global.dart';
import 'package:project_jelly/pages/ghost_mode/tabs/ghost_mode_tab_friends.dart';

class GhostMode extends StatefulWidget {
  const GhostMode({Key? key}) : super(key: key);

  @override
  State<GhostMode> createState() => _GhostModeState();
}

class _GhostModeState extends State<GhostMode>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Ghost Mode',
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
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                          child: Text("Global",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary))),
                      Tab(
                          child: Text("Personal",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary))),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: [GhostModeTabGlobal(), GhostModeTabFriends()],
                  ))
                ],
              ),
            )));
  }
}
