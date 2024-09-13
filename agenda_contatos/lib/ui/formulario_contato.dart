import 'dart:io';
import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:agenda_contatos/ui/pagina_inicial.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormularioContato extends StatefulWidget {
  final Contato? contato;

  const FormularioContato({super.key, this.contato});

  @override
  State<FormularioContato> createState() => _FormularioContatoState();
}

class _FormularioContatoState extends State<FormularioContato> {
  Contato? _contatoEditado;
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorTelefone = TextEditingController();
  final _focusNome = FocusNode();
  bool _usuarioEditado = false;
  ContatoHelper contatoHelper = ContatoHelper();

  @override
  void initState() {
    super.initState();

    if (widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato!.toMap());
      if (_contatoEditado?.nome != null) {
        _controladorNome.text = _contatoEditado!.nome as String;
      }
      if (_contatoEditado?.email != null) {
        _controladorEmail.text = _contatoEditado!.email as String;
      }
      if (_contatoEditado?.telefone != null) {
        _controladorTelefone.text = _contatoEditado!.telefone as String;
      }
    }
  }

  void _voltarParaTelaInicial() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const PaginaInicial(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        print("usuarioEditado: ");
        print(_usuarioEditado);
        if (!_usuarioEditado) {
          _voltarParaTelaInicial();

          return;
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar alterações?"),
              content: const Text("Ao sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _voltarParaTelaInicial();
                  },
                  child: const Text("Sim"),
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            _contatoEditado != null &&
                    _contatoEditado!.nome != null &&
                    _contatoEditado!.nome!.isNotEmpty
                ? _contatoEditado!.nome as String
                : "Novo Contato",
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_contatoEditado?.nome != null &&
                _contatoEditado!.nome!.isNotEmpty) {
              if (widget.contato != null) {
                await contatoHelper
                    .atualiazarContato(_contatoEditado as Contato);
              } else {
                await contatoHelper.salvarContato(_contatoEditado as Contato);
              }
              _voltarParaTelaInicial();
            } else {
              FocusScope.of(context).requestFocus(_focusNome);
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.camera)
                      .then((arquivo) {
                    if (arquivo == null) {
                      return;
                    }
                    setState(() {
                      _contatoEditado!.imagem = arquivo.path;
                    });
                  });
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _contatoEditado?.imagem != null
                          ? FileImage(File(_contatoEditado?.imagem as String))
                          : const AssetImage("imagens/contato.png"),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _controladorNome,
                focusNode: _focusNome,
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (texto) {
                  setState(() {
                    _contatoEditado?.nome = texto;
                  });
                  _usuarioEditado = true;
                },
              ),
              TextField(
                controller: _controladorEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (texto) {
                  _contatoEditado?.email = texto;
                  _usuarioEditado = true;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _controladorTelefone,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
                onChanged: (texto) {
                  _contatoEditado?.telefone = texto;
                  _usuarioEditado = true;
                },
                keyboardType: TextInputType.number,
              )
            ],
          ),
        ),
      ),
    );
  }
}
