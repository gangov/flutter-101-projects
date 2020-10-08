import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:treasure_mapp/picture_screen.dart';
import 'place.dart';

class CameraScreen extends StatefulWidget {
  final Place place;

  CameraScreen(this.place);

  @override
  _CameraScreenState createState() => _CameraScreenState(this.place);
}

class _CameraScreenState extends State<CameraScreen> {
  final Place place;
  CameraController _controller;
  List<CameraDescription> cameras;
  CameraDescription camera;
  Widget cameraPreview;
  Image image;

  _CameraScreenState(this.place);

  @override
  void initState() {
    setCamera().then((_) {
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );
      _controller.initialize().then((snapshot) {
        cameraPreview = Center(child: CameraPreview(_controller));
        setState(() {
          cameraPreview = cameraPreview;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Take Picture'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  await _controller.takePicture(path);
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => PictureScreen(path, place)
                  );
                  Navigator.push(context, route);
                },
              )
            ],
        ),
        body: Container(
          child: cameraPreview,
        ));
  }

  Future setCamera() async {
    cameras = await availableCameras();
    camera = cameras.first;
  }
}
