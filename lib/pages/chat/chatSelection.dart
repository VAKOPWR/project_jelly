import 'package:flutter/material.dart';

class ChatSelection extends StatefulWidget{
  const ChatSelection ({Key? key}) : super(key: key);

  @override
  State<ChatSelection> createState() => _ChatSelectionState();
}

class _ChatSelectionState extends State<ChatSelection>{

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[600],
              title: Text ('Chats'),
              centerTitle: true,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "/map");
                },
              ),
            ),
            body: Container(

              color: Colors.green[600],
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
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    // indicatorColor: Colors.black,
                  ),

                  Expanded(
                      child: TabBarView(
                        children: [

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