import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File file) userImageFn;

  UserImagePicker(this.userImageFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
      children: [
        TextButton(
          onPressed: () async{
            ImagePicker picker = ImagePicker();
            final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
            setState(() {
              _image = File(file!.path);
            });
            widget.userImageFn(_image!);
          },
          child: const Row(
            children: [
              Icon(Icons.camera),
              SizedBox(
                width: 10,
              ),
              Text('Take from camera'),
            ],
          ),
        ),
        TextButton(
          onPressed: () async{
            ImagePicker picker = ImagePicker();
            final file = await picker.pickImage(source: ImageSource.gallery);
            setState(() {
              _image = File(file!.path);
            });
            widget.userImageFn(_image!);

          },
          child: const Row(
            children: [
              Icon(Icons.image),
              SizedBox(
                width: 10,
              ),
              Text('Pick from gallery'),
            ],
          ),
        ),
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
            radius: 40,
            backgroundImage: _image != null ? FileImage(_image!) : null),
        // TextButton.icon(
        //     onPressed: _pickImage,
        //     icon: const Icon(Icons.camera),
        //     label: const Text('Pick Image')),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.lightBlue,
              child: Icon(
                size: 20,
                color: Colors.white,
                Icons.camera_alt_rounded,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
