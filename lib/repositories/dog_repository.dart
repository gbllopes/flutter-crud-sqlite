import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mock_sqlite/datahelper/database_helper.dart';

import '../models/dog.dart';

class DogRepository with ChangeNotifier {
  late Database db;
  List<Dog> dogs = [];

  Future<void> getDogs() async {
    db = await DataBaseHelper.instance.database;
    final resultado = await db.query('dogs');
    List<Dog> dogsSaved = resultado.isNotEmpty
        ? resultado.map((dog) => Dog.fromMap(dog)).toList()
        : [];
    dogs = dogsSaved;
    notifyListeners();
  }

  Future<void> insertDog(Dog dog) async {
    db = await DataBaseHelper.instance.database;
    final resultado = await db.insert(
      'dogs',
      dog.toMap(),
    );
    dogs.add(Dog(id: resultado, name: dog.name));
    notifyListeners();
  }

  Future<void> deleteDog(int id) async {
    db = await DataBaseHelper.instance.database;
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
    dogs = dogs.where((value) => value.id != id).toList();
    notifyListeners();
  }

  Future<void> updateDog(Dog dog) async {
    db = await DataBaseHelper.instance.database;
    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
    dogs[dogs.indexWhere((existingDog) => existingDog.id == dog.id)] = dog;
    notifyListeners();
  }
}
