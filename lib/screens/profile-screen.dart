import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/extensions/extensions.dart';

import '../providers/providers.dart';
import '../widgets/layout.dart';
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
          onTap: () => _goToTakePictureScreen(context),
          child: SizedBox(
              width: 200,
              height: 200,
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

  void _goToTakePictureScreen(BuildContext context) =>
      Navigator.pushNamed(context, AppRoute.takePicture,
          arguments: (fileBytes) async {
        final authProvider = context.read<AuthProvider>();

        try {
          await authProvider.updateProfilePicture(fileBytes);

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSuccessSnackBar(
              'Foto ${authProvider.currentUser?.photoURL != null ? 'atualizada' : 'adicionada'} com sucesso!');
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
        }
      });
}
