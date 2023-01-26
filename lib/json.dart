// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print('directory: ${directory.path}');
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path: $path');
    return File('$path/training.json');
  }

  Future<File> writeJson(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(counter);
  }

  //Future<File> writeCounter(int counter) async {
  //final file = await _localFile;

  // Write the file
  // return file.writeAsString('$counter');
  //}

  Future<Object> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      // return a json object
      return json.decode(contents);

      //return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return objet json vide {}

      return json.encode({});
    }
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  // int _counter = 0;

  String jsonString = jsonEncode({});

  //@override
  //void initState() {
  //super.initState();
  //widget.storage.readCounter().then((int value) {
  //setState(() {
  //_counter = value;
  // });
  // });
  //}

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        jsonString = value as String;
      });
    });
  }

  Future<File> _incrementCounter() {
    var directory = getApplicationDocumentsDirectory();

    print(directory);
    // afficher le json

    setState(() {
      // _counter++;
      jsonString = jsonEncode({
        'name': 'John Smith',
        'email': 'test@mail.com',
        'age': 25,
        'address': {
          'street': '123 Main St',
          'city': 'Anytown',
          'state': 'CA',
          'zip': '12345'
        },
        'phone': [
          {'type': 'home', 'number': '123-456-7890'},
          {'type': 'mobile', 'number': '123-456-7890'}
        ]
      });

      print(jsonString);
    });

    // Write the variable as a string to the file.
    // return widget.storage.writeCounter(_counter);
    return widget.storage.writeJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text('json string: $jsonString'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
