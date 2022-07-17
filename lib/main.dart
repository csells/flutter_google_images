import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_9/google_images.dart';

late final GoogleImages images;

void main() async {
  images = await GoogleImages.search('female half elf mage');
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Google Image Search Example';

  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = (images.images.length / 2).floor();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _index == 0 ? null : _arrowLeft,
                    icon: const Icon(Icons.arrow_left),
                  ),
                  IconButton(
                    onPressed:
                        _index == images.images.length - 1 ? null : _arrowRight,
                    icon: const Icon(Icons.arrow_right),
                  ),
                ],
              ),
              Image.memory(images.images[_index]),
            ],
          ),
        ),
      );

  void _arrowLeft() => setState(() => _index = max(0, _index - 1));

  void _arrowRight() =>
      setState(() => _index = min(images.images.length - 1, _index + 1));
}
