//refer https://flutter.dev/docs/cookbook/plugins/picture-using-camera
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


void main() => runApp(MainApp());

// main widget
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ImageConnect()
    );
  }
}

// image picker
class ImageConnect extends StatefulWidget {
  @override
  _ImageConnectState createState() => _ImageConnectState();
}

class _ImageConnectState extends State<ImageConnect> {
  String imagePath;
  File image;
  final ImagePicker picker = ImagePicker();
  List results;
  bool loading = false;

  // connect source
  Future imageConnect(ImageSource source) async {
    //final img = await picker.getImage(source: ImageSource.camera);
    final PickedFile img = await picker.getImage(source: source);
    if (img != null) {
      imagePath = img.path;
      image = File(img.path);
      loading = true;

      setState(() {});
      classifyImage();
    }
  }

  // TODO RGBより予測モデルから予測結果を取得する
  Future classifyImage() async {
    results = [];
    setState(() {});

    // TODO 読み込みは初期化時にやりたい
    await Tflite.loadModel(model: "assets/model.tflite",
    labels: "assets/label.txt");
    // TODO imageバイナリで渡す方法でやってみたい
    // https://pub.dev/packages/tflite
    var output =  await Tflite.runModelOnImage(
      path: imagePath,
      threshold: 0.001,
      //numResults: 5
       );

    results = output;
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('art genre classify'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: _buildContent(),
      ),
      floatingActionButton: _buildFloatingButton(imageConnect)
    );
  }

  List<Widget> splitResults() {
    if (results == null) return [];
    
    return results.map<Widget>((r) {
      return Text("label ${r["label"]}: ${r["confidence"].toStringAsFixed(3)}");
    }).toList();
  }

  Widget _buildContent() {
    return Column(
      children: <Widget> [
        image == null 
          ? Text('No Image Choosing')
          : Image.file(image, width: 300, height: 400,
               fit: BoxFit.cover),
        loading == false
          ? Container()
          : CircularProgressIndicator(),
        Column(
          children: splitResults(),
        )
      ],
    );
  }

  Widget _buildFloatingButton(Function onPress) {
    //return Scaffold(
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: FloatingActionButton(
            heroTag: "image gallery",
            tooltip: "pick image from gallery",
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.photo_library),
            onPressed: () {
              //cameraConnect(ImageSource.gallery);
              onPress(ImageSource.gallery);
            }
          ),
        ),
        FloatingActionButton(
          heroTag: "image camera",
          backgroundColor: Colors.lightBlue,
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            //cameraConnect(ImageSource.camera);
            onPress(ImageSource.camera);
          }
        ),

      ]
    );
  }
}
