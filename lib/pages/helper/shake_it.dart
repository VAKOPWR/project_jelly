import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:project_jelly/pages/controller/global_shake_controller.dart';
import 'package:project_jelly/service/map_service.dart';

class ShakeItScreen extends StatelessWidget {
  ShakeItScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shake It Screen"),
      ),
      body: Obx(() {
        final isShaking = Get.find<GlobalShakeController>().isShaking.value;
        final friends = Get.find<GlobalShakeController>().shakingFriends;
        return Center(
          child: isShaking
              ? Text("Shaking Detected!")
              : ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return ListTile(
                      title: Text(friend.name),
                      leading: CircleAvatar(
                        backgroundImage: Get.find<MapService>().imageProviders[friend.id],
                        radius: 29,
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
