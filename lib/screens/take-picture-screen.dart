import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef PictureHandler = Future<void> Function(Uint8List);

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

//TODO: Trocar para futureBuilder e gerenciar melhor o código assíncrono. 
// Está estourando algumas exceções indevidas
class TakePictureScreenState extends State<TakePictureScreen> {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      await _initializeCameraController(_cameras!.first);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take a Picture")),
      body: _isInitialized
          ? _cameraPreview()
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _cameraControls(),
    );
  }

  Widget _cameraPreview() => Center(
        child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.primary)),
            child: CameraPreview(_cameraController!)),
      );

  Widget _cameraControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: _switchCamera,
            child: const Icon(Icons.switch_camera),
          ),
          FloatingActionButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera),
          )
        ],
      ),
    );
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.length <= 1) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _initializeCameraController(_cameras![_selectedCameraIndex]);
  }

  void _takePicture() async {
    if (!_isInitialized || _cameraController == null) return;

    final imageFile = await _cameraController!.takePicture();

    Uint8List imageBytes = await imageFile.readAsBytes();

    if (!mounted) return;

    final pictureHandler =
        ModalRoute.of(context)!.settings.arguments as PictureHandler;

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
            imageData: imageBytes,
            onAccept: () => pictureHandler(imageBytes)
                .then((_) => Navigator.of(context).pop())
                .catchError((error) => Navigator.of(context).pop()),
            onReject: () => Navigator.of(context).pop())));
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final Uint8List imageData;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ImagePreviewScreen(
      {super.key,
      required this.imageData,
      required this.onAccept,
      required this.onReject});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Veja a foto")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(FontAwesomeIcons.camera,
                size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            const Text('Você gostou?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ]),
          Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.primary)),
              child: Image.memory(imageData)),
        ],
      )),
      bottomNavigationBar: _buttons(context));

  Widget _buttons(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        TextButton(
            onPressed: onReject,
            child: const Row(children: [
              Icon(FontAwesomeIcons.thumbsDown),
              SizedBox(width: 8),
              Text("Não!")
            ])),
        OutlinedButton(
          onPressed: onAccept,
          child: const Row(
              children: [Icon(FontAwesomeIcons.thumbsUp
              ), SizedBox(width: 8), Text("Sim!")]),
        )
      ]));
}
