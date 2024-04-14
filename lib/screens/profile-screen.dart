import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/constants/app-route.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import '../widgets/layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Layout(
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            _userAvatar(context),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _userInfo(context),
          ])));

  Widget _userAvatar(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final pictureUrl = authProvider.currentUser.photoURL;

    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 6)),
            child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    pictureUrl != null ? NetworkImage(pictureUrl) : null,
                backgroundColor: Colors.transparent,
                child: Center(
                    child: pictureUrl != null
                        ? IconButton(
                            onPressed: () =>
                                _goToTakePictureScreen(context, authProvider),
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary))
                        : IconButton(
                            onPressed: () =>
                                _goToTakePictureScreen(context, authProvider),
                            icon: Icon(Icons.person_add,
                                color:
                                    Theme.of(context).colorScheme.primary))))));
  }

  Widget _userInfo(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(children: [
        Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 8),
            Text(authProvider.currentUser.displayName!)
          ],
        ),
        const SizedBox(height: 16),
        Row(children: [
          const Icon(Icons.email),
          const SizedBox(width: 8),
          Text(authProvider.currentUser.email!)
        ])
      ]),
    );
  }

  void _goToTakePictureScreen(
          BuildContext context, AuthProvider authProvider) =>
      AppRoute.navigateToTakePictureScreen(
          context,
          (fileBytes) async => authProvider
              .updateProfilePicture(fileBytes)
              .then((value) => Navigator.pop(context))
              .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.greenAccent,
                      content: Text('Foto de perfil atualizada com sucesso!'))))
              .catchError((_) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text('Erro ao salvar a foto de perfil.')))));
}
