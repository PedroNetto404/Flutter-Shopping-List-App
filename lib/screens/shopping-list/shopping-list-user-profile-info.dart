import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';

import '../../services/auth-service.dart';

class ShoppingListUserProfileInfo extends StatefulWidget {
  const ShoppingListUserProfileInfo({super.key});

  @override
  State<ShoppingListUserProfileInfo> createState() => _ShoppingListUserProfileInfoState();
}

class _ShoppingListUserProfileInfoState extends State<ShoppingListUserProfileInfo> {
  final _authService = AuthService();
  String? _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = _authService.currentUser!.photoURL;
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            maxRadius: MediaQuery.of(context).size.width * 0.15,
            minRadius: MediaQuery.of(context).size.width * 0.15,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage:
            _currentImage != null ? NetworkImage(_currentImage!) : null,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
              ),
              child: Center(
                  child: _currentImage == null
                      ? IconButton(
                      icon: const Icon(Icons.person_add, size: 30),
                      onPressed: () => _goToTakePictureScreen(context))
                      : IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _goToTakePictureScreen(context))),
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                _authService.currentUser!.displayName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  _goToTakePictureScreen(context) =>
      AppRoute.navigateTo(context, AppRoute.takePicture,
          arguments: _onPictureTaken);

  Future<void> _onPictureTaken(XFile xFile) async {
    await _authService.updateProfilePicture(File(xFile.path));

    setState(() {
      _currentImage = _authService.currentUser!.photoURL;
    });
  }
}
