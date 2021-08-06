import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hellomnist/model/classifier.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final picker = ImagePicker();
  Classifier classifier = Classifier();
  late XFile image;
  int digit = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          image = (await picker.pickImage(source: ImageSource.gallery))!;
          digit = await classifier.classifyImage(image);
          //digit = 22;
          setState(() {});
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.camera_alt_outlined),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(child: Text("Digit Analyzer")),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Image will be shown below",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                image: DecorationImage(
                  image: digit == -1
                      ? AssetImage("assets/bg.jpg")
                      : FileImage(File(image.path)) as ImageProvider,
                ),
              ),
            ),
            SizedBox(
              height: 45.0,
            ),
            Text(
              "Current Predictions: ",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              digit == -1 ? "" : "$digit",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
