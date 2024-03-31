import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true
      ),
      body: Center(
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: const Text(
                              'Não possui uma conta? Crie uma agora!')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.forgotPassword);
                          },
                          child: const Text('Esqueceu sua senha?'))
                    ]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.shoppingList);
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
    );
  }
}
