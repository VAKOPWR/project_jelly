import 'package:flutter/material.dart';
import 'package:project_jelly/pages/ghost_mode/tabs/ghost_mode_tab_global.dart';
import 'package:project_jelly/pages/ghost_mode/tabs/ghost_mode_tab_friends.dart';

class GhostMode extends StatefulWidget {
  const GhostMode({Key? key}) : super(key: key);

  @override
  State<GhostMode> createState() => _GhostModeState();
}

class _GhostModeState extends State<GhostMode> {
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Ghost Mode'),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: const Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: 'Global',
                      ),
                      Tab(
                        text: 'Friends',
                      )
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [GhostModeTabGlobal(), GhostModeTabFriends()],
                  ))
                ],
              ),
            )));
  }
}
