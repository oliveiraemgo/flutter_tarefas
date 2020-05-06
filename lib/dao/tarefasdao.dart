import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tarefas/modelos/tarefas.dart';

class Dao{

  final String queryTabela = "CREATE TABLE tarefas("
      + "id INTEGER PRIMARY KEY,"
      + "titulo TEXT,"
      + "descricao TEXT,"
      + "finalizado INTEGER,"
      + "excluido INTEGER)";

  Future<Database> banco() async {
    return openDatabase(
      join(await getDatabasesPath(), "tarefas_database.db"),
      onCreate: (db, version) {
        return db.execute(queryTabela);
      },
      version: 3,
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        switch (oldVersion){
          case 1:
            db.execute("ALTER TABLE tarefas ADD COLUMN finalizado INTEGER");
            continue versao_2;

            versao_2:
          case 2:
            db.execute("ALTER TABLE tarefas ADD COLUMN excluido INTEGER");
        }
      }
    );

  }


  Future<void> inserir(Tarefas tarefa) async {
    final Database db = await banco();

    //inserindo
    await db.insert(
        'tarefas',
        tarefa.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  Future<void> remover(int id) async {

    final db = await banco();

    await db.delete(
        "tarefas",
        where: "id = ?",
        whereArgs: [id]
    );
  }


  Future<List<Tarefas>> listar() async {

    final Database db = await banco();

    //query simples
    //final List<Map<String, dynamic>> map = await db.query('tarefas');

    //query com parametros
    final List<Map<String, dynamic>> map = await db.rawQuery("SELECT * FROM tarefas WHERE excluido = 0", null);

    return Tarefas.mapToList(map);
  }


  Future<List<Tarefas>> listarLixeira() async {
    final Database db = await banco();
    final List<Map<String, dynamic>> map = await db.rawQuery("SELECT * FROM tarefas WHERE excluido = 1", null);
    return Tarefas.mapToList(map);
  }


  Future<void> moverParaLixeira(int id) async {

    final db = await banco();

    await db.update(
        "tarefas",
        { "excluido" : 1 },
        where: "id = ?" ,
        whereArgs: [id]
    );
  }


  Future<void> removerDaLixeira(int id) async {

    final db = await banco();

    await db.update(
      "tarefas",
      { "excluido" : 0 },
      where: "id = ?",
      whereArgs: [id]
    );
  }


  Future<void> finalizar(int id) async {

    final db = await banco();

    await db.update(
      "tarefas",
      { "finalizado" : 1 },
      where: "id = ?",
      whereArgs: [id]
    );
  }

}