
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PermissionStatus _permissionStatus = PermissionStatus.granted;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    final status = await Permission.storage.status;
    setState(() {
      _permissionStatus = status;
    });
    if(_permissionStatus != PermissionStatus.granted){
      _requestPermission();
    }
  }

  void _requestPermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _permissionStatus = status;
    });
  }




    void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueAccent[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Image Picker'),
      ),
      body: _permissionStatus == PermissionStatus.granted
          ? Center(
        child: _imageFile == null
            ? const Text('No image selected.')
            : Image.file(
          _imageFile!,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      )
          : Center(
        child: Text(
            'Storage permission is required \nto pick an image.\n$_permissionStatus'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _permissionStatus == PermissionStatus.granted ? _pickImage : null,
        child: const Icon(Icons.image),
      ),
    );
  }
}
