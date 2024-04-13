import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/conditional-loading.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initFuture;
  final List<CameraController> _camerasControllers = [];
  final List<CameraDescription> _cameras = [];

  CameraController get _currentCameraController =>
      _camerasControllers[_selectedCameraIndex];

  int _selectedCameraIndex = 0;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();

    _initFuture = _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras.addAll(await availableCameras());

    for (var camera in _cameras) {
      final cameraController =
          CameraController(camera, ResolutionPreset.medium);
      await cameraController.initialize();

      _camerasControllers.add(cameraController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pictureHandler = ModalRoute.of(context)!.settings.arguments
        as Future<void> Function(XFile);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tire uma foto'),
        ),
        body: _buildBody(pictureHandler),
        persistentFooterButtons: [
          FloatingActionButton(
            onPressed: _onCameraChange,
            child: const Icon(Icons.switch_camera),
          ),
          FloatingActionButton(
            onPressed: () => _onPictureTaken(pictureHandler, context),
            child: const Icon(Icons.camera),
          ),
        ]);
  }

  Widget _buildBody(Future<void> Function(XFile) pictureHandler) =>
      FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) => ConditionalLoading(
          predicate: () =>
              snapshot.connectionState == ConnectionState.waiting ||
              _isTakingPicture,
          childBuilder: (_) => CameraPreview(_currentCameraController),
        ),
      );

  void _onCameraChange() {
    if (_camerasControllers.length < 2) return;

    setState(() {
      _selectedCameraIndex =
          (_selectedCameraIndex + 1) % _camerasControllers.length;
    });
  }

  void _onPictureTaken(
      Future<void> Function(XFile) pictureHandler, BuildContext context) {
    _currentCameraController
        .takePicture()
        .then(pictureHandler)
        .then((_) => Navigator.pop(context))
        .catchError((e) {
          print(e);
      _showErrorSnackBar(context);
    }).whenComplete(() => setState(() => _isTakingPicture = false));

    setState(() => _isTakingPicture = true);
  }

  void _showErrorSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao tirar a foto'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
}
