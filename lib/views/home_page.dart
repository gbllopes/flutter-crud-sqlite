import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dog.dart';
import '../repositories/dog_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DogRepository dogRepository;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dogRepository = Provider.of<DogRepository>(context);
    dogRepository.getDogs();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form-dog');
                  },
                  icon: Icon(Icons.add),
                  label: Text('Adicionar cachorro')),
            ),
            dogRepository.dogs.isEmpty
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: dogRepository.dogs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          title: Text(dogRepository.dogs[index].name!),
                          leading: ClipOval(
                            child: Image.asset(
                              'assets/images/dog-icon.png',
                              width: 35,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/form-dog',
                                    arguments: Dog(
                                      id: dogRepository.dogs[index].id,
                                      name: dogRepository.dogs[index].name,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.blue[400],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  dogRepository
                                      .deleteDog(dogRepository.dogs[index].id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
