import 'package:sqflite/sqflite.dart';

import 'package:mock_sqlite/datahelper/database_helper.dart';

import '../models/dog.dart';

class DogRepository {
  late Database db;

  Future<List<Dog>> getDogs() async {
    db = await DataBaseHelper.instance.database;
    final resultado = await db.query('dogs');
    List<Dog> dogs = resultado.isNotEmpty
        ? resultado.map((dog) => Dog.fromMap(dog)).toList()
        : [];
    return dogs;
  }

  Future<int> insertDog(Dog dog) async {
    db = await DataBaseHelper.instance.database;
    final resultado = await db.insert(
      'dogs',
      dog.toMap(),
    );
    return resultado;
  }

  Future<void> deleteDog(int id) async {
    db = await DataBaseHelper.instance.database;
    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
}
