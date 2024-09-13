import 'dart:io';
import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:agenda_contatos/ui/formulario_contato.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum OpcoesOrdenacao { crescente, decrescente }

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  ContatoHelper contatoHelper = ContatoHelper();
  List<Contato> contatosLista = [];

  @override
  void initState() {
    super.initState();
    _buscarTodosContatos();
  }

  void _exibirFormularioContato({Contato? contato}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioContato(
          contato: contato,
        ),
      ),
    );
  }

  void _buscarTodosContatos() {
    contatoHelper.buscarTodosContatos().then((lista) {
      setState(() {
        contatosLista = lista;
      });
    });
  }

  void _ordenarLista(OpcoesOrdenacao opcao) {
    switch(opcao) {
      case OpcoesOrdenacao.crescente:
        contatosLista.sort((a, b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
        break;
      case OpcoesOrdenacao.decrescente:
        contatosLista.sort((a, b) => b.nome!.toLowerCase().compareTo(a.nome!.toLowerCase()));
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<OpcoesOrdenacao>(
            itemBuilder: (context) => <PopupMenuEntry<OpcoesOrdenacao>>[
              const PopupMenuItem<OpcoesOrdenacao>(
                value: OpcoesOrdenacao.crescente,
                child: Text("Ordenar de A-Z"),
              ),
              const PopupMenuItem<OpcoesOrdenacao>(
                value: OpcoesOrdenacao.decrescente,
                child: Text("Ordenar de Z-A"),
              )
            ],
            onSelected: _ordenarLista,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirFormularioContato();
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contatosLista.length,
        itemBuilder: (context, index) {
          return _cartaoContato(context, index);
        },
      ),
    );
  }

  _exibirOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          launchUrlString(
                            "tel:${contatosLista[index].telefone}",
                          );
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Ligar",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _exibirFormularioContato(
                            contato: contatosLista[index],
                          );
                        },
                        child: const Text(
                          "Editar",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          contatoHelper
                              .excluirContato(contatosLista[index].id as int);
                          setState(() {
                            contatosLista.removeAt(index);
                          });
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Widget _cartaoContato(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _exibirOpcoes(context, index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatosLista[index].imagem != null
                        ? FileImage(File(contatosLista[index].imagem as String))
                        : const AssetImage("imagens/contato.png"),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatosLista[index].nome ?? "Não Informado",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contatosLista[index].email ?? "Não Informado",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contatosLista[index].telefone ?? "Não Informado",
                      style: const TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
