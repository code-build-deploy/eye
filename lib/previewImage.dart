// import 'dart:typed_data';
import 'package:eye/preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

class PreviewImage extends StatefulWidget {

  final String imgFilePath;
  PreviewImage({
    @required this.imgFilePath
  });

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {

  List<Rect> rect = new List<Rect>();
  List<Widget> stackList = new List<Widget>();

  makePreds() async{
    stackList.add(
      Center(
        child: Container(
          child: Image.file(
            File(widget.imgFilePath),
            fit: BoxFit.cover,
          ),
        ),
      )
    );

    stackList.add(
      Center(
        child: Container(
          color: Colors.black38,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      )
    );

    setState(() {

    });
    
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(
      File(widget.imgFilePath)
    );

    var options = FaceDetectorOptions(
      enableTracking: true,
      enableClassification: true,
      enableLandmarks: true,
      mode: FaceDetectorMode.accurate
    );


    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
      options
    );

    final List<Face> faces = await faceDetector.processImage(visionImage);
    
    if (rect.length > 0) {
      rect.clear();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);
    }

    stackList.removeAt(stackList.length - 1);

    var imageFile;

    imageFile = await File(widget.imgFilePath).readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ImageAndPeople(
          imageFile: imageFile,
          faces: faces,
          rect: rect
        )
      )
    );
  }

  @override
  void initState() {
    makePreds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: stackList.length == 0 ? Center(
          child: CircularProgressIndicator(),
        ) : Stack(
          children: stackList,
        ),
      ),
    );
  }
}