import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-user-profile-info.dart';
import '../../contants/app-route.dart';
import '../../services/auth-service.dart';
import '../../widgets/theme-selector.dart';

class ShoppingListUserDrawer extends StatelessWidget {
  final _authService = AuthService();

  ShoppingListUserDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: ShoppingListUserProfileInfo(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('Sobre'),
                          onTap: () =>
                              AppRoute.navigateTo(context, AppRoute.about),
                        ),
                        ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Sair'),
                          onTap: () => _onSignOutPressed(context),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20, right: 20),
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: ThemeSelector(),
                        )),
                  ]),
            )
          ],
        ),
      );

  void _onSignOutPressed(BuildContext context) => _authService
      .signOut()
      .then((value) => AppRoute.navigateTo(context, AppRoute.home))
      .catchError((error) => _showSnackBarError(context));

  _showSnackBarError(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Erro ao sair da aplicação')));
}
