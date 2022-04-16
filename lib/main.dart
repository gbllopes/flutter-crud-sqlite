import 'package:flutter/material.dart';
import 'package:mock_sqlite/repositories/dog_repository.dart';

import 'models/dog.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter CRUD with SQLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AcaoFormulario { salvar, editar }

class _MyHomePageState extends State<MyHomePage> {
  DogRepository dogRepository = DogRepository();
  List<Dog> dogs = [];
  var acaoFormulario = AcaoFormulario.salvar;

  @override
  void initState() {
    dogRepository.getDogs().then((listaDogs) {
      setState(() {
        dogs = listaDogs;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _controllerTxtField = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _controllerTxtField,
              decoration: InputDecoration(
                  label: Text('Nome do cachorro'),
                  hintText: 'Digite o nome do cachorro'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  title: Text(dogs[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllerTxtField.text = dogs[index].name;
                            acaoFormulario = AcaoFormulario.editar;
                          });
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.blue[400],
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          Dog dog = dogs[index];
                          try {
                            setState(() {
                              dogs = dogs
                                  .where((value) => value.id != dog.id)
                                  .toList();
                            });

                            dogRepository.deleteDog(dog.id!);
                          } catch (error) {
                            setState(() {
                              dogs.add(dog);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Dog dog = Dog(name: _controllerTxtField.text);
              try {
                int idDog = await dogRepository.insertDog(dog);
                setState(() {
                  if (acaoFormulario == AcaoFormulario.salvar) {
                    dogs.add(Dog(id: idDog, name: dog.name));
                  } else {
                    acaoFormulario = AcaoFormulario.salvar;
                  }
                });
              } catch (error) {
                setState(() {
                  dogs.remove(dog);
                });
              }
            },
            child: Text(acaoFormulario == AcaoFormulario.salvar
                ? 'Salvar'
                : 'Atualizar'),
          )
        ],
      ),
    );
  }
}
