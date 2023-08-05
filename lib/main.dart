import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaginaInicial(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _contador = 0;

  bool get estaVazio => _contador == 0;

  bool get estaCheio => _contador == 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/imagem.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              estaCheio ? 'LOTADO' : 'Pode Entrar',
              style: TextStyle(
                fontSize: 30,
                color: estaCheio ? Colors.red : Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                _contador.toString(),
                style: TextStyle(
                  color: estaCheio ? Colors.red : Colors.white,
                  fontSize: 100,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: estaVazio ? null : decrementar,
                  style: TextButton.styleFrom(
                    backgroundColor: estaVazio
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white,
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Saiu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                TextButton(
                  onPressed: estaCheio ? null : incrementar,
                  style: TextButton.styleFrom(
                    backgroundColor: estaCheio
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white,
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),   
                  ),
                  child: const Text(
                    'Entrou',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void decrementar() {
    setState(() {
      _contador--;
    });
  }

  void incrementar() {
    setState(() {
      _contador++;
    });
  }
}
