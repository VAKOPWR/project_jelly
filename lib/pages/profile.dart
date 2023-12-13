import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jelly/classes/basic_user.dart';
import 'package:project_jelly/logic/auth.dart';
import 'package:project_jelly/pages/auth/login.dart';
import 'package:project_jelly/service/request_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameController = TextEditingController();

  XFile? image;
  String userAvatarProfileLink = "";

  final ImagePicker picker = ImagePicker();

  String userName = '';

  @override
  void initState() {
    loadBasicUserInfo();
    super.initState();
  }

  Future<void> loadBasicUserInfo() async {
    BasicUser? basicUser =
        await Get.find<RequestService>().getBasicUserResponseFromCurrentUser();
    if (basicUser != null) {
      setState(() {
        userName = basicUser.name;
        userAvatarProfileLink = basicUser.avatar!;
      });
    }
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  Future<void> myAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    String _newUserAvatar = "";
    if (image != null) {
      _newUserAvatar =
          await Get.find<RequestService>().asyncProfileAvatarFileUpload(image!);
    } else {
      _newUserAvatar = FirebaseAuth.instance.currentUser!.photoURL!;
    }

    setState(() {
      userAvatarProfileLink = _newUserAvatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(250),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Text("Profile",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authLogOut().then((value) => Get.offAll(
                      () => const LogInPage(),
                      transition: Transition.rightToLeft));
                },
              ),
            ],
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(userAvatarProfileLink),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 30,
                      child: GestureDetector(
                        onTap: myAlert,
                        child: CircleAvatar(
                          radius: 15,
                          child: Icon(Icons.add_a_photo, size: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nickname text
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  userName,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              // Description text
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularButton(
                    icon: Icons.edit,
                    onPressed: _showUsernameEditDialog,
                  ),
                  CircularButton(
                      icon: Icons.settings, destinationPath: '/settings'),
                  CircularButton(
                      icon: Icons.remove_red_eye_outlined,
                      destinationPath: '/ghost_mode'),
                ],
              ),
            ],
          ),
        ));
  }

  void _showUsernameEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(36.0),
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text("Edit Username"),
            content: TextField(
              controller: _usernameController,
              maxLength: 10,
              decoration: InputDecoration(labelText: 'New Username'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  bool usernameChangeSuccess = await Get.find<RequestService>()
                      .changeUsername(_usernameController.text);
                  Navigator.of(context).pop();
                  if (usernameChangeSuccess) {
                    loadBasicUserInfo();
                    Get.snackbar(
                        "Congratulations", "Username was successfully changed",
                        icon: Icon(Icons.sentiment_satisfied_alt_outlined,
                            color: Colors.white, size: 35),
                        snackPosition: SnackPosition.TOP,
                        isDismissible: false,
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green[400],
                        margin: EdgeInsets.zero,
                        snackStyle: SnackStyle.GROUNDED);
                  } else {
                    Get.snackbar(
                        "Oooooops...", "Something went wrong, please try again",
                        icon: Icon(Icons.sentiment_very_dissatisfied_outlined,
                            color: Colors.white, size: 35),
                        snackPosition: SnackPosition.TOP,
                        isDismissible: false,
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red[400],
                        margin: EdgeInsets.zero,
                        snackStyle: SnackStyle.GROUNDED);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final String? destinationPath;
  final VoidCallback? onPressed;

  CircularButton({
    required this.icon,
    this.destinationPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else if (destinationPath != null) {
          Navigator.pushNamed(context, destinationPath!);
        }
      },
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 42.0,
          ),
        ),
      ),
    );
  }
}
