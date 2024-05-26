import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

Future<void> camera() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MaterialApp(
    theme: ThemeData.dark(), // 앱의 전반적인 테마를 다크 테마로 설정합니다.
    home: TakePictureScreen(camera: firstCamera), // 홈 스크린으로 TakePictureScreen을 설정하고, 선택된 카메라를 전달합니다.
  ));
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  // 생성자를 통해 카메라 객체를 전달받습니다. 필수로 전달받아야 하므로 @required로 표시합니다.
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}
// TakePictureScreen의 상태를 관리하는 클래스입니다.
class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller; // 카메라 컨트롤러
  late Future<void> _initializeControllerFuture; // 컨트롤러 초기화 작업을 담당할 Future 객체
  @override
  void initState() {
    super.initState();
    // CameraController 인스턴스를 생성합니다. 카메라 설정은 해상도를 중간으로 설정합니다.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    // 컨트롤러의 초기화를 비동기로 진행합니다.
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose() {
    // 위젯이 dispose될 때, 카메라 컨트롤러도 dispose하여 리소스를 해제합니다.
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('카메라 예제')), // 앱바 제목 설정
      // 비동기 작업을 다루기 위해 FutureBuilder를 사용합니다.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // Future가 완료되면, 즉 카메라 초기화가 끝나면 카메라 미리보기를 보여줍니다.
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller); // 카메라 미리보기 위젯
          } else {
            // 아직 로딩 중이라면 로딩 인디케이터를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // 버튼이 눌리면 사진을 캡처하는 기능을 수행합니다.
        onPressed: () async {
          try {
            // 컨트롤러 초기화를 기다립니다.
            await _initializeControllerFuture;

            // 사진 캡처를 시도하고 결과를 저장합니다.
            final image = await _controller.takePicture();

            // 캡처된 사진을 보여주는 화면으로 이동합니다.
            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e); // 에러가 발생한 경우 콘솔에 에러를 출력합니다.
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  // 생성자를 통해 이미지 경로를 전달받습니다.
  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사진 보기')), // 앱바 제목 설정
      // 파일 시스템에서 이미지를 로드하여 화면에 표시합니다.
      body: Image.file(File(imagePath)),
    );
  }
}