import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'results.dart';

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
          style: TextStyle(
            color: Colors.white
          ),
        ),
        subtitle: Text(
          item.trackingId.toString(),
          style: TextStyle(
            color: Colors.white
          ),
        ),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            height: 2 * MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
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
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: tiles
            )
          )
        ],
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
      ..strokeWidth = 9.0
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