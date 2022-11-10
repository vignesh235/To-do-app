import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/widgets/button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class todo extends StatefulWidget {
  const todo({super.key});

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Image.file(_image!),
            custombutten(title: "test", icon: Icons.camera, onClick: pickImage)
          ],
        ),
      ),
    );
  }

  File? _image;
  Future pickImage() async {
    String dir;
    String pdf_name;
    String pathttt;
    File file;
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.camera);

      // final paths = await getApplicationDocumentsDirectory();
      if (file == null) return;
      setState(() {
        _image = File(file.path);
        // pathttt = '$paths/${image}';
        print(File(file.path));
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
