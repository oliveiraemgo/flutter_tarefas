class Tarefas{

  int id;
  String titulo;
  String descricao;
  bool finalizado;
  bool excluido;

  Tarefas({this.id, this.titulo, this.descricao, this.excluido, this.finalizado});

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "titulo" : titulo,
      "descricao" : descricao,
      "finalizado" : finalizado == null ? 0 : (finalizado ? 1 : 0),
      "excluido" : excluido == null ? 0 : (excluido ? 1 : 0)
    };

    if (id != null && id != 0)
      map["id"] = id;

    return map;
  }

  static List<Tarefas> mapToList(List<Map<String, dynamic>> map){
    return List.generate(map.length, (i) {
      return Tarefas(
          id: map[i]["id"],
          titulo: map[i]["titulo"],
          descricao: map[i]["descricao"],
          excluido: map[i]["excluido"] == 1,
          finalizado: map[i]["finalizado"] == 1
      );
    });
  }


  Tarefas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    finalizado = json['finalizado'];
    excluido = json['excluido'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    data['finalizado'] = this.finalizado;
    data['excluido'] = this.excluido;
    return data;
  }


}