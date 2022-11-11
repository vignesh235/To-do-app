import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/widgets/button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

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
            _image != null
                ? Image.file(_image!)
                : Image.network(
                    "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            custombutten(title: "test", icon: Icons.camera, onClick: pickImage),
            // api(title: "API", icon: Icons.camera, onClick: upimage)
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

      final paths = await getApplicationDocumentsDirectory();
      if (file == null) return;
      setState(() {
        _image = File(file.path);
        pathttt = '$paths/${_image}';
        print(File(file.path));
        File imageFile = File(file.path);
        uploadimage(imageFile);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

//   Future upimage() async {
//     print("check");
//     var response = await http.post(
//         Uri.parse(
//             """http://192.168.24.68:8001/api/method/frappe.client.set_value?doctype=User&name=barath@gmail.com&fieldname=user_image&value=${_image}"""),
//         headers: {"Authorization": "token 0675f9dacd165b0:4aaf0fe2233ff04"});
//     response.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')));
//     print(response);
//     print(response.body);
//     print(response.statusCode);
//   }
// }
  Future uploadimage(paths) async {
    print("working");
    var length = await paths.length();
    Dio dio = new Dio();
    try {
      String filename = paths.path.split("/").last;
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print(filename);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(paths.path, filename: filename),
        "docname": "barath@gmail.com",
        "doctype": 'User',
        "attached_to_name": "barath@gmail.com",
        "is_private": 0,
        "attached_to_field": "user_image",
        "folder": "Home/Attachments"
      });

      var dio = Dio();

      dio.options.headers["Authorization"] =
          "token 5fbc807b69674df:3de4edb08e8f18f";

      var response = await dio.post(
        "https://fargodev.thirvusoft.co.in/api/method/upload_file",
        data: formData,
      );

      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print(response.data.runtimeType);
      print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      print(response.data['message']['file_url']);
      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      // print(json.decode(response.toString()));
      print("ddddddddddddddddddddddddddddddddddddddddd");
      if (response.statusCode == 200) {
        var img_response = await http.post(
            Uri.parse(
                "https://fargodev.thirvusoft.co.in/api/method/frappe.client.set_value?doctype=User&name=barath@gmail.com&fieldname=user_image&value=${response.data['message']['file_url']}"),
            headers: {
              "Authorization": "token 5fbc807b69674df:3de4edb08e8f18f"
            });
        print(img_response.statusCode);
        print(img_response.body);
      }
      // print(img_response.data);

      // print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
