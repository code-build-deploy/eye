// import 'package:eye/results.dart';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'results.dart';

import 'dart:ui' as ui;

// import 'package:image/image.dart' as imgLib;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File pickedImage;
  var imageFile;
  List<Rect> rect = new List<Rect>();
  List<Face> listOfFaces;

  bool displayImage = false;

  bool isFaceDetected = false;
  
  pickImageFromGallery() async{
    var awaitImage = await ImagePicker().getImage(source: ImageSource.gallery);

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      imageFile = imageFile;
      pickedImage = File(awaitImage.path);
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

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

    setState(() {
      isFaceDetected = true;
      displayImage = true;
      listOfFaces = faces;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(image: AssetImage("assets/devil-mask.jpg"),fit: BoxFit.cover)
//      ),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: displayImage ? ImageAndPeople(
          imageFile: imageFile,
          faces: listOfFaces,
          rect: rect
        ) : Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.8
            ),
            Center(
              child: FlatButton.icon(
                icon: Icon(
                  Icons.photo_camera,
                  size: 100,
                ),
                label: Text(''),
                textColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  pickImageFromGallery();
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.8
            )
          ],
        ),
        floatingActionButton: displayImage ? FloatingActionButton(
          onPressed: () async {
            setState(() {
              rect.clear();
            });
            pickImageFromGallery();
          },
          child: Icon(
            Icons.camera_alt
          ),
        ) : Container(),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}

// ignore: must_be_immutable
class ImageAndPeople extends StatelessWidget {

  var imageFile;
  final List<Face> faces;
  final List<Rect> rect;

  ImageAndPeople({
    @required this.imageFile,
    @required this.faces,
    @required this.rect
  });

  List<Widget> tiles = new List<Widget>();

  @override
  Widget build(BuildContext context) {

    int i = 0;

    for (var item in faces){
      i = i + 1;
      var newTile = ListTile(
        title: Text(
          "Person " + i.toString(),
          style: TextStyle(fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            shadows: [Shadow(
              blurRadius: 10,
              color: Colors.black45,
              offset: Offset(5,5),
            )]
          ),
        ),
//        subtitle: Text(
//          item.trackingId.toString(),
//        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PersonDetails(
                rect: item.boundingBox,
                face: item,
                image: imageFile,
                person: (item.trackingId + 1).toString(),
              )
            )
          );
        },
      );
      tiles.add(newTile);
    }

    return Column(
      children: <Widget>[
        Container(
          height: 2 * MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          // child: Image.file(imageFile)

          child: Center(
            child: FittedBox(
              child: SizedBox(
                width: imageFile.width.toDouble(),
                height: imageFile.height.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                    imageFile,
                    faces
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: (MediaQuery.of(context).size.height / 3),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cyberpunk.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.red,
                BlendMode.darken,
              ),
            ),
    gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ([Colors.red,Colors.black45.withOpacity(0.1)]),

            ),
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0)
            ),
          ),

            child: ListView(
              children: tiles
            ),
        )
      ],
    );
  }
}