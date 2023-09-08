import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_jelly/logic/permissions.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    bool galleryPermisiion = await requestGalleryPermission();

    if (galleryPermisiion) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        print('User canceled picture selection');
      }
    } else {
      print('No gallery permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                width: 150,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Avatar'),
            ),
            // Add a "Next" button to proceed to the next step
          ],
        ),
      ),
    );
  }
}
