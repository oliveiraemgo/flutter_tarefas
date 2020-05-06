import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/dao/tarefasdao.dart';
import 'package:tarefas/modelos/tarefas.dart';

class Lixeira extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LixeiraState();
  }
}


class LixeiraState extends State<Lixeira> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _lista(),
    );
  }


  Widget _appBar(){
    return AppBar(
      title: Text("Lixeira"),
    );
  }


  Widget _lista(){
    return FutureBuilder(
      future: Dao().listarLixeira(),
      builder: (context, snapshot) {
        List<Tarefas> tarefas = snapshot.data;
        return ListView.builder(
            itemBuilder: (BuildContext context, int index){
              Tarefas tarefa = tarefas[index];
              return _item(tarefa);
            },
            itemCount: tarefas == null ? 0 : tarefas.length,
        );
      },
    );
  }


  Widget _item(Tarefas tarefa){
    return GestureDetector(
      child: _itemCard(tarefa),
      onLongPress: () {
        _itemOnLongPress(tarefa.id);
      },
    );
  }


  Widget _itemCard(Tarefas tarefa){
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _itemIcone(),
                _itemTitulo(tarefa.titulo)
              ],
            ),
            Row(
              children: <Widget>[
                _itemDescricao(tarefa.descricao)
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget _itemIcone(){
    return Container(
      padding: EdgeInsets.only(
        left: 0,
        top: 0,
        right: 5,
        bottom: 2
      ),
      child: Icon(
        Icons.restore_from_trash,
        color: Colors.red,
      ),
    );
  }


  Widget _itemTitulo(titulo){
    return Flexible(
      child: Text(
        titulo,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  Widget _itemDescricao(descricao){
    return Flexible(
      child: Text(
        descricao
      ),
    );
  }


  void _itemOnLongPress(int id){
    var builder = AlertDialog(
      title: Text("Deseja recuperar esta tarefa?"),
      actions: <Widget>[
        FlatButton(
          child: Text("NÃO", style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("SIM", style: TextStyle(color: Colors.black)),
          onPressed: () {
            _removerDaLixeira(id);
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => builder
    );
  }


  void _removerDaLixeira(int id){
    setState(() {
      Dao().removerDaLixeira(id);
    });
  }
}