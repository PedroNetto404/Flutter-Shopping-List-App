import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../extensions/extensions.dart';

typedef PictureHandler = Future<void> Function(Uint8List);

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  final List<CameraDescription> _camerasDescriptions = [];
  CameraController? _currentCameraController;

  int _selectedCameraIndex = 0;
  bool _takingPicture = false;
  bool _currentCameraInitialized = false;

  get _currentCameraDescription => _camerasDescriptions[_selectedCameraIndex];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    _currentCameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_currentCameraController == null ||
        !_currentCameraController!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _currentCameraController!.dispose();
      return;
    }

    if (state != AppLifecycleState.resumed) return;

    _changeCurrentCamera();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Tire uma foto")),
      body: _currentCameraInitialized && !_takingPicture
          ? Column(
              children: [
                _title(),
                _cameraPreview(),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _cameraControls());

  Widget _title() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.faceSmileBeam,
              size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Sorria!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      );

  Widget _cameraPreview() => Expanded(
        child: Center(
          child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.primary)),
              child: CameraPreview(_currentCameraController!)),
        ),
      );

  Widget _cameraControls() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        if (_camerasDescriptions.length > 1)
          FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedCameraIndex =
                      (_selectedCameraIndex + 1) % _camerasDescriptions.length;
                  _currentCameraInitialized = false;
                });
                _changeCurrentCamera();
              },
              child: const Icon(Icons.switch_camera)),
        FloatingActionButton(
            onPressed: _takePicture, child: const Icon(FontAwesomeIcons.camera))
      ]));

  Future<void> _init() async {
    _camerasDescriptions.addAll(await availableCameras());

    await _changeCurrentCamera();
  }

  Future<void> _changeCurrentCamera() async {
    try {
      if (_currentCameraController != null) {
        await _currentCameraController!
            .setDescription(_currentCameraDescription);
      } else {
        _currentCameraController = CameraController(
          _currentCameraDescription,
          ResolutionPreset.high,
          enableAudio: false,
        );
      }

      await _currentCameraController!.initialize();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(error);
    }

    if (!mounted) return;

    setState(() => _currentCameraInitialized =
        _currentCameraController!.value.isInitialized);

    if (!_currentCameraController!.hasListeners) {
      _currentCameraController!.addListener(() {
        setState(() {});

        if (_currentCameraController!.value.hasError) {
          ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(
              _currentCameraController!.value.errorDescription!);
        }
      });
    }
  }

  Future<void> _takePicture() async {
    if (_currentCameraController == null ||
        !_currentCameraController!.value.isInitialized ||
        _takingPicture) return;

    setState(() => _takingPicture = true);

    try {
      final imageFile = await _currentCameraController!.takePicture();

      final imageBytes = await imageFile.readAsBytes();

      if (!mounted) return;

      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
              imageData: imageBytes,
              onAccept: () => _onAcceptPicture(imageBytes),
              onReject: () {
                if (_takingPicture) return;

                Navigator.of(context).pop();
              })));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }

    if (!mounted) return;

    setState(() => _takingPicture = false);
  }

  void _onAcceptPicture(Uint8List imageBytes) async {
    if (!mounted) return;

    try {
      final pictureHandler =
          ModalRoute.of(context)!.settings.arguments as PictureHandler;

      await pictureHandler(imageBytes);

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class ImagePreviewScreen extends StatefulWidget {
  final Uint8List imageData;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ImagePreviewScreen(
      {super.key,
      required this.imageData,
      required this.onAccept,
      required this.onReject});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _savingImage = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Veja a foto")),
      body: Center(
          child: _savingImage
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(FontAwesomeIcons.camera,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      const Text('Você gostou?',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                    ]),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          child: Image.memory(widget.imageData)),
                    ),
                  ],
                )),
      bottomNavigationBar: _buttons(context));

  Widget _buttons(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        TextButton(
            onPressed: widget.onReject,
            child: const Row(children: [
              Icon(FontAwesomeIcons.thumbsDown),
              SizedBox(width: 8),
              Text("Não!")
            ])),
        OutlinedButton(
            onPressed: () {
              if (_savingImage) return;

              setState(() {
                _savingImage = true;
              });

              widget.onAccept();
            },
            child: const Row(children: [
              Icon(FontAwesomeIcons.thumbsUp),
              SizedBox(width: 8),
              Text("Sim!")
            ]))
      ]));
}
