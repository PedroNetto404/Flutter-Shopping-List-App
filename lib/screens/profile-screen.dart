import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';

import '../widgets/layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    profilePictureUrl = _authService.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    var user = _authService.currentUser;
    if(user == null) throw Exception('User not found');

    return Layout(
        body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage: profilePictureUrl != null
                ? NetworkImage(profilePictureUrl!)
                : null,
            child: Center(
                child: profilePictureUrl == null
                    ? IconButton(
                        icon: const Icon(Icons.person_add, size: 30),
                        onPressed: () => _goToTakePictureScreen(context))
                    : IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _goToTakePictureScreen(context))),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Text(user.displayName!)
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8),
                  Text(user.email!)
                ])
              ],
            ))
      ]),
    ));
  }

  void _goToTakePictureScreen(BuildContext context) =>
      AppRoute.navigateTo(context, AppRoute.takePicture,
          arguments: _handlePicture);

  Future<void> _handlePicture(XFile xFile) async {
    var file = File(xFile.path);
    await _authService.updateProfilePicture(file);

    setState(() => profilePictureUrl = _authService.currentUser?.photoURL);
  }
}
