import 'camerascreen.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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

  // File pickedImage;
  // var imageFile;
  // List<Rect> rect = new List<Rect>();
  // List<Face> listOfFaces;

  // bool displayImage = false;

  // bool isFaceDetected = false;
  
  // pickImageFromGallery() async{
  //   var awaitImage = await ImagePicker().getImage(source: ImageSource.gallery);

  //   imageFile = await awaitImage.readAsBytes();
  //   imageFile = await decodeImageFromList(imageFile);

  //   setState(() {
  //     imageFile = imageFile;
  //     pickedImage = File(awaitImage.path);
  //   });

  //   FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

  //   var options = FaceDetectorOptions(
  //     enableTracking: true,
  //     enableClassification: true,
  //     enableLandmarks: true,
  //     mode: FaceDetectorMode.accurate
  //   );


  //   final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
  //     options
  //   );

  //   final List<Face> faces = await faceDetector.processImage(visionImage);
    
  //   if (rect.length > 0) {
  //     rect.clear();
  //   }
  //   for (Face face in faces) {
  //     rect.add(face.boundingBox);
  //   }

  //   setState(() {
  //     isFaceDetected = true;
  //     displayImage = true;
  //     listOfFaces = faces;
  //   });
    
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CameraScreen(),
    );

    // return Scaffold(
    //   body: displayImage ? ImageAndPeople(
    //     imageFile: imageFile,
    //     faces: listOfFaces,
    //     rect: rect
    //   ) : Column(
    //     children: <Widget>[
    //       SizedBox(
    //         height: MediaQuery.of(context).size.height / 2.8
    //       ),
    //       Center(
    //         child: FlatButton.icon(
    //           icon: Icon(
    //             Icons.photo_camera,
    //             size: 100,
    //           ),
    //           label: Text(''),
    //           textColor: Theme.of(context).primaryColor,
    //           onPressed: () async {
    //             pickImageFromGallery();
    //           },
    //         ),
    //       ),
    //       SizedBox(
    //         height: MediaQuery.of(context).size.height / 2.8
    //       )
    //     ],
    //   ),
    //   floatingActionButton: displayImage ? FloatingActionButton(
    //     onPressed: () async {
    //       setState(() {
    //         rect.clear();            
    //       });
    //       pickImageFromGallery();
    //     },
    //     child: Icon(
    //       Icons.camera_alt
    //     ),
    //   ) : Container(),
    // );
  }
}
