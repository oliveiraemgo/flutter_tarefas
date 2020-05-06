import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/dao/tarefasdao.dart';
import 'package:tarefas/modelos/tarefas.dart';
import 'package:tarefas/telas/formulario/formulario.dart';
import 'package:tarefas/telas/lixeira/lixeira.dart';
import 'package:toast/toast.dart';

class Main extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _Main();
  }


}

class _Main extends State<Main>{
  List<Tarefas> tarefas;
  List<Tarefas> novasTarefas;

  List<String> menu = ["Sair"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _lista(),
      floatingActionButton: _btnIncluir(),
    );
  }

  Widget _appBar(){
    return AppBar(
      title: Text("Tarefas"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.restore_from_trash),
          tooltip: "Lixeira",
          onPressed: () {
            var rota = MaterialPageRoute(
              builder: (context) => Lixeira()
            );
            Navigator.push(context, rota);
          },
        ),
        PopupMenuButton<String>(
          tooltip: "menu",
          onSelected: (str) {

          },
          itemBuilder: (BuildContext context){
            return menu.map((String m) {
              return PopupMenuItem<String>(
                value: m,
                child: Text(m),
              );
            }).toList();
          },
        )
      ],
    );
  }


  Widget _btnIncluir(){
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: "Nova tarefa",
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => Formulario(
                  tarefa: Tarefas(),
                )
            )
        );
      },
    );
  }


  Widget _lista(){
    return FutureBuilder(
      future: Dao().listar(),
      builder: (context, snapshot) {
        tarefas = snapshot.data;
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

  _removerItem(int id){
    setState(() {
      Dao().moverParaLixeira(id);
    });
  }

  _finalizarItem(int id){
    setState(() {
      Dao().finalizar(id);
    });
  }


  Widget _item(Tarefas tarefa){
    return GestureDetector(
      onTap: () {
        Route rota = MaterialPageRoute(builder: (context) => Formulario(
            tarefa: tarefa
        ));
        Navigator.push(context, rota);
      },
      onLongPress: () {
        _itemOnLongPress(
            tarefa: tarefa
        );
      },
      child: _itemCard(tarefa),
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
                 _itemIcone(tarefa),
                  _itemTitulo(tarefa.titulo)
                ],
              ),
              Row(
                children: <Widget>[
                  _itemDescricao(tarefa.descricao)
                ],
              ),
            ],
          )
      ),
    );
  }


  Widget _itemIcone(Tarefas tarefa){
    return Container(
      padding: EdgeInsets.only(
          left: 0,
          top: 0,
          right: 5,
          bottom: 2
      ),
      child: Icon(
        Icons.check_box,
        color: tarefa.finalizado ? Colors.green : Colors.black26
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


  void _itemOnLongPress({ Tarefas tarefa }) {

    var alerta = AlertDialog(
      title: Text("Atenção"),
      content: Text("O que deseja fazer com a tarefa: ${tarefa.titulo}?"),
      actions: <Widget>[
        FlatButton(
          child: Text("MOVER PARA LIXEIRA"),
          onPressed: () {
            _removerItem(tarefa.id);
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("FINALIZAR"),
          onPressed: () {

            if (tarefa.finalizado) {
              Toast.show("Item já finalizado", context,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM
              );
              return null;
            }

            _finalizarItem(tarefa.id);
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => alerta
    );
  }

}