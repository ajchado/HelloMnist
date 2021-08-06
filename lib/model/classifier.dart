import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;
import 'package:tflite/tflite.dart';

class Classifier {
  Classifier();

  classifyImage(XFile image) async {
    var _file = io.File(image.path);
    img.Image? imageTemp = img.decodeImage(_file.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp!, height: 28, width: 28);
    var imgBytes = resizedImg.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  Future<int> getPred(Uint8List imgAslist) async {
    List resultBytes = List<int>.filled(28, 28, growable: false);

    int index = 0;
    for (int i = 0; i < imgAslist.lengthInBytes; i += 4) {
      final r = imgAslist[i];
      final g = imgAslist[i + 1];
      final b = imgAslist[i + 2];

      resultBytes[index] = ((r + g + b) / 3.0) / 255.0;
      index++;
    }

    var input = resultBytes.reshape([1, 28, 28, 1]);
    var output = List<int>.filled(1, 10, growable: false).reshape([1, 10]);

    //InterpreterOptions interpreterOptions = InterpreterOptions();

    try {
      Interpreter interpreter = await Interpreter.fromAsset(
        "model.tflite",
        //options: interpreterOptions,
      );
      interpreter.run(input, output);
    } catch (e) {
      print("Error loading model");
    }

    double highestProb = 0;
    int digitPred = 0;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        digitPred = i;
      }
    }

    return digitPred;
  }
}
