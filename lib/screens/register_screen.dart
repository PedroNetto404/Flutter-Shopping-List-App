import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie sua conta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crie sua conta',
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
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
              ),
            ),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(206, 83, 83, 1),
                foregroundColor: Colors.black,
              ),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}