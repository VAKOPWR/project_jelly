import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  const ChatPage ({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 3,
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
                      ),
                      Tab(
                        text: 'Proximity',
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