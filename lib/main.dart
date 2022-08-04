import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_images/google_images.dart';

void main() => runApp(const App());

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
  late final TextEditingController _controller;
  Future<GoogleImages>? _future;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'female half elf mage');
    _onSearch();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: _onSearch, child: const Text('Search'))
                  ],
                ),
              ),
              FutureBuilder<GoogleImages>(
                future: _future,
                builder: ((context, snapshot) {
                  if (_future == null) {
                    return Container();
                  }

                  if (snapshot.hasError) {
                    return const Text('error');
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  assert(snapshot.hasData);
                  return SearchResults(snapshot.data!);
                }),
              ),
            ],
          ),
        ),
      );

  void _onSearch() {
    _future = GoogleImages.search(_controller.text);
    setState(() {});
  }
}

class SearchResults extends StatefulWidget {
  final GoogleImages images;

  const SearchResults(this.images, {super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _onSetImages();
  }

  @override
  void didUpdateWidget(covariant SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onSetImages();
  }

  void _onSetImages() => _index = (widget.images.images.length / 2).floor();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _index == 0 ? null : _onArrowLeft,
              icon: const Icon(Icons.arrow_left),
            ),
            IconButton(
              onPressed: _index == widget.images.images.length - 1
                  ? null
                  : _onArrowRight,
              icon: const Icon(Icons.arrow_right),
            ),
          ],
        ),
        Image.memory(widget.images.images[_index]),
      ],
    );
  }

  void _onArrowLeft() => setState(() => _index = max(0, _index - 1));

  void _onArrowRight() =>
      setState(() => _index = min(widget.images.images.length - 1, _index + 1));
}
