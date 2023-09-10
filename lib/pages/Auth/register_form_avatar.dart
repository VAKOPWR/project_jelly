import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jelly/logic/auth.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/pages/home.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/widgets/dialogs.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  File? _selectedImage;
  final RoundedLoadingButtonController _submitBtnController =
      RoundedLoadingButtonController();

  Future<void> _pickImage() async {
    bool galleryPermisiion = false;
    if (Platform.isAndroid) {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      AndroidDeviceInfo android = await plugin.androidInfo;
      if (android.version.sdkInt >= 33) {
        galleryPermisiion = true;
      } else {
        galleryPermisiion = await requestGalleryPermission();
      }
    } else {
      galleryPermisiion = await requestGalleryPermission();
    }
    if (galleryPermisiion) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        log('User canceled picture selection');
      }
    } else {
      log('No gallery permission');
    }
  }

  Future<void> _submitImage() async {
    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? const IOSDialogWidget(
                  dialogHeader: 'Oooops...',
                  dialogText: 'Please, select an image to proceed')
              : const AndroidDialogWidget(
                  dialogHeader: 'Oooops...',
                  dialogText: 'Please, select an image to proceed');
        },
      );
      _submitBtnController.reset();
    } else {
      bool setImageSuccess =
          await apiSetProfileImage('somekey', FileImage(_selectedImage!));

      if (setImageSuccess) {
        _submitBtnController.success();
        Get.offNamed('/register_friends');
      } else {
        _submitBtnController.error();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32.0),
            const Text(
              'Welcome to the Jelly!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Set your avatar so your friends may easily identify you.",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 32.0),
            CircleAvatar(
              radius: 150.0,
              backgroundColor: Colors.grey,
              backgroundImage: _selectedImage != null
                  ? FileImage(
                      File(_selectedImage!.path),
                    )
                  : null,
              child: _selectedImage == null
                  ? const Icon(
                      Icons.person,
                      size: 200.0,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(
                Icons.upload_file,
                size: 30,
              ),
              label: const Text('Select avatar',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RoundedLoadingButton(
                    controller: _submitBtnController,
                    onPressed: _submitImage,
                    color: Colors.blue,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  )),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Get.off(() => const LoadingPage(nextScreen: HomePage()));
              },
              child: const Text(
                'SKIP',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
