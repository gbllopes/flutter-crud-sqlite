import 'package:flutter/material.dart';
import 'package:mock_sqlite/repositories/dog_repository.dart';
import 'package:provider/provider.dart';

import 'models/dog.dart';
import 'views/dog_form_view.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (create) => DogRepository(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SQLite MOCK'),
      routes: {
        '/home-page': (context) => MyHomePage(title: 'SQLite MOCK'),
        '/form-dog': (context) => DogFormView(),
      },
    );
  }
}
