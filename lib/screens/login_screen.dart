import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                'Listify',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(206, 83, 83, 1),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Color.fromRGBO(50, 50, 50, 1)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Entre com suas credenciais',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () => {
                              Navigator.pushNamed(
                                  context, Routes.forgotPassword)
                            },
                        child: const Text('Esqueceu a senha?'))),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(206, 83, 83, 1),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Entrar'),
                ),
              ],
            ),
          ),
        ));
  }
}
