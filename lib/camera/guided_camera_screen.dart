// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'display_image_screen.dart';

// class GuidedCameraScreen extends StatefulWidget {
//   final String filterImage;
//   final String idNumber;

//   const GuidedCameraScreen({
//     super.key,
//     required this.filterImage,
//     required this.idNumber,
//   });

//   @override
//   _GuidedCameraScreenState createState() => _GuidedCameraScreenState();
// }

// class _GuidedCameraScreenState extends State<GuidedCameraScreen> {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//    bool _isTakingPicture = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller!.initialize();
//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 CameraPreview(_controller!),
//                 Opacity(
//                   opacity: 0.5,
//                   child: Image.asset(
//                     widget.filterImage,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 20.0),
//                     child: FloatingActionButton(
//                       onPressed: _takePicture,
//                     backgroundColor: Color(0xFF87C159),
//                       child: const Icon(Icons.camera_alt,color: Colors.white,),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'display_image_screen.dart';

class GuidedCameraScreen extends StatefulWidget {
  final String filterImage;
  final String idNumber;

  const GuidedCameraScreen({
    super.key,
    required this.filterImage,
    required this.idNumber,
  });

  @override
  _GuidedCameraScreenState createState() => _GuidedCameraScreenState();
}

class _GuidedCameraScreenState extends State<GuidedCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      final controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _controller = controller;
      _initializeControllerFuture = controller.initialize();

      if (mounted) setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture) return;

    try {
      _isTakingPicture = true;
      await _initializeControllerFuture;

      if (_controller == null || !_controller!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }

      final image = await _controller!.takePicture();

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayImageScreen(
              imagePath: image.path,
              idNumber: widget.idNumber,
              filterImage: widget.filterImage,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
    } finally {
      _isTakingPicture = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _controller?.dispose();
        return true;
      },
      child: Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_controller!),
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      widget.filterImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: FloatingActionButton(
                        onPressed: _takePicture,
                        backgroundColor: const Color(0xFF87C159),
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
