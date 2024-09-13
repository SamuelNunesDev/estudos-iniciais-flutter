import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tabelaContatos = 'contatos';
const String colunaId = 'id';
const String colunaNome = 'nome';
const String colunaEmail = 'email';
const String colunaTelefone = 'telefone';
const String colunaImagem = 'url_imagem';

class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper.internal();

  factory ContatoHelper() => _instance;

  ContatoHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await inicializarBanco();

    return _db!;
  }

  Future<Database> inicializarBanco() async {
    final diretorioBanco = await getDatabasesPath();
    final diretorio = join(diretorioBanco, "contatos.db");

    return await openDatabase(diretorio, version: 1,
        onCreate: (Database db, int versaoRecente) async {
      await db.execute("CREATE TABLE $tabelaContatos("
          "$colunaId INTEGER PRIMARY KEY,"
          "$colunaNome TEXT,"
          "$colunaEmail TEXT,"
          "$colunaTelefone TEXT,"
          "$colunaImagem TEXT"
          ")");
    });
  }

  Future<Contato> salvarContato(Contato contato) async {
    Database banco = await db;
    contato.id = await banco.insert(tabelaContatos, contato.toMap());

    return contato;
  }

  Future<Contato?> buscarContato(int id) async {
    Database banco = await db;
    List<Map> mapas = await banco.query(
      tabelaContatos,
      columns: [
        colunaId,
        colunaNome,
        colunaEmail,
        colunaTelefone,
        colunaImagem
      ],
      where: "$colunaId = ?",
      whereArgs: [id],
    );
    if (mapas.isNotEmpty) {
      return Contato.fromMap(mapas.first);
    }
    return null;
  }

  Future<int> excluirContato(int id) async {
    Database banco = await db;

    return await banco.delete(
      tabelaContatos,
      where: "$colunaId = ?",
      whereArgs: [id],
    );
  }

  Future<int> atualiazarContato(Contato contato) async {
    Database banco = await db;

    return await banco.update(
      tabelaContatos,
      contato.toMap(),
      where: "$colunaId = ?",
      whereArgs: [contato.id],
    );
  }

  Future<List<Contato>> buscarTodosContatos() async {
    Database banco = await db;
    List listaContatos = await banco.rawQuery("SELECT * FROM $tabelaContatos");
    List<Contato> listaContatosFormatados = [];
    for(Map m in listaContatos) {
      listaContatosFormatados.add(Contato.fromMap(m));
    }
    return listaContatosFormatados;
  }

  Future encerrarBanco() async {
    Database banco = await db;
    banco.close();
  }
}

class Contato {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? imagem;

  Contato();

  Contato.fromMap(Map map) {
    id = map[colunaId];
    nome = map[colunaNome];
    email = map[colunaEmail];
    telefone = map[colunaTelefone];
    imagem = map[colunaImagem];
  }

  Map<String, Object?> toMap() {
    Map<String, dynamic> map = {
      colunaNome: nome,
      colunaEmail: email,
      colunaTelefone: telefone,
      colunaImagem: imagem
    };
    if (id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  @override
  String toString() {
    String contato = "Contato(id: $id, nome: $nome, email: $email,";
    contato += "telefone: $telefone, imagem: $imagem)";

    return contato;
  }
}
