import 'package:flutter/material.dart';
import 'package:project_jelly/pages/ghostModeSettings/ghostModeTabEveryone.dart';
import 'package:project_jelly/pages/ghostModeSettings/ghostModeTabFriends.dart';
import 'package:project_jelly/pages/ghostModeSettings/ghostModeTabGroups.dart';

class GhostMode extends StatelessWidget {
  const GhostMode({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[600],
            title: Text ('Ghost Mode'),
            centerTitle: true,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                // Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, "/map");
              },
            ),
          ),
          body: Container(
            // decoration: BoxDecoration(
            //   color: Colors.green[600],
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.8), // Shadow color
            //       spreadRadius: 15, // Spread radius
            //       blurRadius: 20, // Blur radius
            //       offset: Offset(0, 10), // Offset
            //     ),
            //   ],
            // ),
            color: Colors.green[600],
            child: const Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: 'Everyone',
                    ),
                    Tab(
                      text: 'Groups',
                    ),
                    Tab(
                      text: 'Friends',
                    )
                  ],
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  // indicatorColor: Colors.black,
                ),

                Expanded(
                    child: TabBarView(
                      children: [
                        GhostModeTabEveryone(),
                        GhostModeTabGroups(),
                        GhostModeTabFriends()
                      ],
                    )
                )
              ],
            ),
          )

        )
    );
  }
}