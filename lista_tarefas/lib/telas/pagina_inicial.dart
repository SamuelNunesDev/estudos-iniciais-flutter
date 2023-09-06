import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_tarefas/controladores/pagina_inicial_controlador.dart';

class PaginaInicial extends StatelessWidget {
  PaginaInicial({super.key});

  final TextEditingController tarefaController = TextEditingController();
  final PaginaInicialController paginaController = PaginaInicialController();

  void criarTarefa() {
    if(tarefaController.text.isNotEmpty) {
      paginaController.criarTarefa(
        tarefaController.text,
      );
      tarefaController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (_) => criarTarefa(),
                    controller: tarefaController,
                    decoration: const InputDecoration(labelText: 'Nova Tarefa'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 13,
                        ),
                      ),
                      onPressed: () => criarTarefa(),
                      child: const Text('Adicionar'),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: paginaController.ordenarTarefas,
              child: Obx(
                () => ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: paginaController.listaTarefas.length,
                    itemBuilder: _itemLista),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemLista(context, index) {
    return Dismissible(
      key: Key('item-lista-${paginaController.listaTarefas[index].titulo}'),
      onDismissed: (_) => paginaController.deletarTarefa(context, index),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: CheckboxListTile(
        title: Text(paginaController.listaTarefas[index].titulo),
        onChanged: (concluida) => paginaController.alterarTarefa(
          concluida ?? false,
          paginaController.listaTarefas[index],
        ),
        value: paginaController.listaTarefas[index].concluida,
        secondary: CircleAvatar(
          child: Icon(
            paginaController.listaTarefas[index].concluida
                ? Icons.check
                : Icons.error,
          ),
        ),
      ),
    );
  }
}
