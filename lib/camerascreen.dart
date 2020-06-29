import 'package:eye/previewImage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCamera){
      cameras = availableCamera;
      if(cameras.length > 0){
        setState(() {
          selectedCameraIdx = 0;
        });
        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }
      else{
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
  }

  void _onCapturePressed(context) async {
    try {
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      await controller.takePicture(path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PreviewImage(
            imgFilePath: path
          )
        )
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: <Widget>[
          Container(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _cameraPreviewWidget(),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.height,
                child: FlareActor(
                  "assets/flares/Google Lens Anim.flr",
                  fit: BoxFit.cover,
                  animation: "active"
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.height,
                child: FlareActor(
                  "assets/flares/Google Lens Anim.flr",
                  fit: BoxFit.cover,
                  animation: "active"
                ),
              )
            ],
          ),
          Positioned(
            top: 32,
            right: 16,
            child: InkWell(
              onTap: () async{
                var res = await ImagePicker().getImage(source: ImageSource.gallery);
                if(res.path.isNotEmpty){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PreviewImage(
                        imgFilePath: res.path,
                      )
                    )
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 18
                ),
                child: Icon(
                  Icons.photo_album,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _onCapturePressed(context);
        },
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}