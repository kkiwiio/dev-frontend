import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'camera_capture.dart';


late List<CameraDescription> _cameras;
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Request RunTime Permission in Android Flutter"),
          ),
          body: SafeArea(
              child: Center(
                child: AppState(),
              ))),
    );
  }
}

class AppState extends StatefulWidget {
  @override
  AppPermission createState() => AppPermission();
}

class AppPermission extends State<AppState> {

  Future<void> requestCameraPermission() async {

    final serviceStatus = await Permission.camera.isGranted ;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
      camera();
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }



  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Request Runtime Camera Permission'),
                onPressed: requestCameraPermission,
              ),
            ),

          ],
        ));
  }
}