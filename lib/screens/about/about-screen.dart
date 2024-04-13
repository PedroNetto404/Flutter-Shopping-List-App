import 'package:flutter/material.dart';
import 'app-section.dart';
import 'developer-picture.dart';
import 'developer-section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sobre'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSection(),
                  SizedBox(height: 40),
                  DeveloperSection(),
                  SizedBox(height: 40),
                  DeveloperPicture()
                ],
              ),
            ),
          ),
        ),
      );
}
