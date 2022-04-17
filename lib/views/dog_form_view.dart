import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dog.dart';
import '../repositories/dog_repository.dart';

class DogFormView extends StatefulWidget {
  DogFormView({
    Key? key,
  }) : super(key: key);

  @override
  _DogFormViewState createState() => _DogFormViewState();
}

enum AcaoFormulario { salvar, editar }

class _DogFormViewState extends State<DogFormView> {
  late DogRepository dogRepository;
  var acaoFormulario = AcaoFormulario.salvar;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dogRepository = Provider.of<DogRepository>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    final _controllerTxtField = TextEditingController();

    Dog dogSelected = Dog();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      setState(() {
        dogSelected = ModalRoute.of(context)!.settings.arguments as Dog;
        acaoFormulario = AcaoFormulario.editar;
      });
      _controllerTxtField.text = dogSelected.name!;
    }

    return Scaffold(
      appBar: AppBar(
        title: acaoFormulario == AcaoFormulario.salvar
            ? Text('Salvar Cachorro')
            : Text('Editar Cachorro'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Esse campo não pode ser vazio';
                  }

                  if (text.length > 10) {
                    return 'Nome muito longo, tamanho máximo de caracteres: 10';
                  }
                },
                controller: _controllerTxtField,
                decoration: InputDecoration(
                    label: Text('Nome do cachorro'),
                    hintText: 'Digite o nome do cachorro',
                    border: OutlineInputBorder()),
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final validate = formKey.currentState?.validate();
                      if (validate != null && validate) {
                        if (acaoFormulario == AcaoFormulario.salvar) {
                          await dogRepository
                              .insertDog(Dog(name: _controllerTxtField.text));
                        } else {
                          await dogRepository.updateDog(Dog(
                              id: dogSelected.id,
                              name: _controllerTxtField.text));
                          acaoFormulario = AcaoFormulario.salvar;
                        }
                        Navigator.of(context)
                            .pushReplacementNamed('/home-page');
                      }
                    },
                    label: Text(acaoFormulario == AcaoFormulario.salvar
                        ? 'Salvar'
                        : 'Atualizar'),
                    icon: Icon(Icons.save),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
