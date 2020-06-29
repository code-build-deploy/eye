import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class PersonDetails extends StatelessWidget {

  final ui.Image image;

  final String person;

  final Rect rect;
  final Face face;

  PersonDetails({
    @required this.rect,
    @required this.face,
    @required this.image,
    @required this.person
  });

  @override
  Widget build(BuildContext context) {

    var detailsCard = Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.face,
              color: Colors.white,
              size: 40,
            ),
            title: Text(
              "Person " + person + "",
              style: TextStyle(
                fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(
                    blurRadius: 10,
                    color: Colors.black45,
                    offset: Offset(5,5),
                  )]
              ),
            ),
            subtitle: Text(
              'Smiling Probability: ' + face.smilingProbability.toStringAsFixed(4),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    shadows: [Shadow(
                      blurRadius: 10,
                      color: Colors.black45,
                      offset: Offset(5,5),
                    )]
                ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: SizedBox(
                    width: image.width.toDouble(),
                    height: image.height.toDouble(),
                    child: CustomPaint(
                      painter: FacePainter(
                        image: image,
                        face: face,
                        rect: rect,
                        height: MediaQuery.of(context).size.height.toInt(),
                        width: MediaQuery.of(context).size.width.toInt()
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
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
                    colors: ([Colors.red,Colors.black45.withOpacity(0.95)]),

                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                  ),
                ),
                child: detailsCard,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final Face face;
  final Rect rect;
  final int height, width;

  FacePainter({
    @required this.face,
    @required this.rect,
    @required this.image,
    @required this.height,
    @required this.width
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // var centerCoords = rect.center;
    // canvas.translate(height - (2 * centerCoords.dx), width - (2 * centerCoords.dy));
    // canvas.scale(2);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, Paint());
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return true;
  }
}