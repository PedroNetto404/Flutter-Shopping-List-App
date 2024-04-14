import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/conditional-loading.dart';
import '../widgets/layout.dart';

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
  bool _takingPicture = false;

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

    return Layout(
        body: FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) => ConditionalLoadingIndicator(
        predicate: () =>
            snapshot.connectionState == ConnectionState.waiting ||
            _takingPicture,
        childBuilder: (context) => Column(
          children: [
            _header(),
            _cameraSection(pictureHandler),
          ],
        ),
      ),
    ));
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt,
                size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Tire uma foto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _cameraSection(Future<void> Function(XFile) pictureHandler) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CameraPreview(_currentCameraController,
              child: Container(
                  decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
                color: Colors.transparent,
              ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_camerasControllers.length > 1)
                  FloatingActionButton(
                    onPressed: _onCameraChange,
                    child: const Icon(Icons.switch_camera),
                  ),
                FloatingActionButton(
                  onPressed: () => _onPictureTaken(pictureHandler, context),
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          ),
        ],
      );

  void _onCameraChange() {
    if (_camerasControllers.length < 2) return;

    setState(() => _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _camerasControllers.length);
  }

  void _onPictureTaken(
      Future<void> Function(XFile) pictureHandler, BuildContext context) {
    _takingPicture = true;
    _currentCameraController.takePicture().then((file) {
      if (!mounted) return;
      _showPictureFeedbackDialog(XFile(file.path), pictureHandler, context);
    }).catchError((error) {
      if (!mounted) return;
      _handleError(context, error);
    }).whenComplete(() {
      if (!mounted) return;
      setState(() => _takingPicture = false);
    });
  }

  void _handleError(BuildContext context, Object error) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            children: [
              const Text('Erro ao tirar a foto'),
              Text(error.toString()),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

  void _showPictureFeedbackDialog(XFile picture, Function(XFile) pictureHandler,
          BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Gostou da foto?'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(File(picture.path)),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Não')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto salva com sucesso!'),
                          ),
                        );
                      },
                      child: const Text('Sim')),
                ],
              ));
}
