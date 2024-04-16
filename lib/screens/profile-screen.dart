import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Layout(
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            _userAvatar(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _userInfo(context),
          ])));

  Widget _userAvatar() => Consumer<AuthProvider>(builder:
          (BuildContext context, AuthProvider provider, Widget? child) {
        final pictureUrl = provider.currentUser!.photoURL;

        return GestureDetector(
          onTap: () => _goToTakePictureScreen(context, provider),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 6)),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          pictureUrl != null ? NetworkImage(pictureUrl) : null,
                      backgroundColor: Colors.transparent,
                      child: Center(
                          child: Icon(
                            color: Theme.of(context).colorScheme.primary,
                            pictureUrl != null
                              ? FontAwesomeIcons.penToSquare
                              : FontAwesomeIcons.camera))))),
        );
      });

  Widget _userInfo(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(children: [
        Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 8),
            Text(authProvider.currentUser!.displayName!)
          ],
        ),
        const SizedBox(height: 16),
        Row(children: [
          const Icon(Icons.email),
          const SizedBox(width: 8),
          Text(authProvider.currentUser!.email!)
        ])
      ]),
    );
  }

  void _goToTakePictureScreen(
          BuildContext context, AuthProvider authProvider) =>
      AppRoute.navigateTo(context, AppRoute.takePicture,
          arguments: (imageBytes) =>
              _handleImageBytes(context, authProvider, imageBytes));

  Future<void> _handleImageBytes(
      BuildContext context, AuthProvider authProvider, Uint8List bytes) async {
    try {
      await authProvider.updateProfilePicture(bytes);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(children: [
        Icon(FontAwesomeIcons.bug),
        SizedBox(width: 8),
        Text(
            'Ops... ocorreu um erro ao atualizar a foto de perfil. Tente novamente mais tarde.')
      ])));
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(children: [
          Icon(FontAwesomeIcons.circleCheck),
          SizedBox(width: 8),
          Text('Foto de perfil atualizada com sucesso!')
        ])));
      }
    }
  }
}
