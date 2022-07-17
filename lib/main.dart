import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() async {
  final images = await GoogleImages.search('male half orc barbarian');
  print(images.images[(images.images.length / 2).floor()]);
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Flutter App';

  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: HomePage(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: const Center(
          child: Text('hello, world'),
        ),
      );
}

class GoogleImages {
  static final _re = RegExp(r"_setImgSrc\('\d+','(?<data>[^']+)'\);");
  static const Map<String, String> _headers = {
    HttpHeaders.userAgentHeader:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
  };

  final List<Uint8List> images;
  GoogleImages(this.images);

  static Future<GoogleImages> search(String search) async {
    final res = await http.get(
      Uri.parse('https://www.google.com/search?q=$search&tbm=isch&sclient=img'),
      headers: _headers,
    );

    if (res.statusCode != HttpStatus.ok) return GoogleImages([]);

    final images = parse(res.body)
        .querySelectorAll('script')
        .map((e) => e.text)
        .where((t) => t.startsWith('_setImgSrc'))
        .map((t) => _re
            .firstMatch(t)!
            .namedGroup('data')
            .toString()
            .split(',')[1]
            .replaceAll(r'\/', r'/')
            .replaceAll(r'\x3d', r'='))
        .map((encoded) => base64.decode(encoded))
        .toList();

    return GoogleImages(images);
  }
}
