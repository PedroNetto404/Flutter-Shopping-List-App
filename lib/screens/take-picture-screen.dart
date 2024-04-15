import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/layout.dart';

class TakePictureScreen extends StatefulWidget {
  final Future<void> Function(Uint8List) handler;

  const TakePictureScreen({super.key, required this.handler});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initFuture;
  final List<CameraController> _camerasControllers = [];

  CameraController get _currentCameraController =>
      _camerasControllers[_selectedCameraIndex];

  int _selectedCameraIndex = 0;
  bool _takingPicture = false;

  @override
  void dispose() {
    for (var controller in _camerasControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _initCameras().catchError((error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao inicializar a câmera: ${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future<void> _initCameras() async {
    final cameras = await availableCameras();

    for (var camera in cameras) {
      final cameraController =
          CameraController(camera, ResolutionPreset.medium);

      if (!cameraController.value.isInitialized) {
        await cameraController.initialize();
      }

      _camerasControllers.add(cameraController);
    }
  }

  @override
  Widget build(BuildContext context) => Layout(
        body: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                _takingPicture) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao inicializar a câmera'));
            }

            return Column(
              children: [
                _header(),
                _cameraSection(),
              ],
            );
          },
        ),
      );

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

  Widget _cameraSection() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CameraPreview(_currentCameraController,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 4,
                    ),
                    color: Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
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
                            onPressed: () => _onPictureTaken(context),
                            child: const Icon(Icons.camera),
                          ),
                        ],
                      ),
                    ),
                  ))),
        ),
      );

  void _onCameraChange() {
    if (_camerasControllers.length < 2) return;

    setState(() => _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _camerasControllers.length);
  }

  void _onPictureTaken(BuildContext context) {
    _currentCameraController
        .takePicture()
        .then((value) => value.readAsBytes())
        .then((value) => _showPictureFeedbackDialog(value, context))
        .catchError((error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao tirar a foto'),
        backgroundColor: Colors.red,
      ));
    }).whenComplete(() {
      if (!mounted) return;

      setState(() => _takingPicture = false);
    });

    setState(() => _takingPicture = true);
  }

  void _showPictureFeedbackDialog(Uint8List picture, BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Gostou da foto?'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 4,
                          )),
                      child: Image.memory(picture)),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Não')),
                  TextButton(
                      onPressed: () =>
                          _onPictureConfirmedPressed(picture, context),
                      child: const Text('Sim')),
                ],
              ));

  void _onPictureConfirmedPressed(Uint8List picture, BuildContext context) =>
      widget.handler(picture).catchError((error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao salvar a foto'),
          backgroundColor: Colors.red,
        ));
      }).whenComplete(() => Navigator.of(context).pop());
}
