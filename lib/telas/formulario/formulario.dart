import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarefas/dao/tarefasdao.dart';
import 'package:tarefas/modelos/tarefas.dart';
import 'package:toast/toast.dart';

class Formulario extends StatefulWidget{

  Tarefas tarefa;

  Formulario({ Key key, @required this.tarefa }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormularioState(tarefa: tarefa);
  }

}

class FormularioState extends State<Formulario>{

  Tarefas tarefa;
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  FormularioState({ Key key, @required this.tarefa }) : super() {
    tituloController.text = tarefa.titulo;
    descricaoController.text = tarefa.descricao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _btnSalvar(),
    );
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  //Toolbar
  Widget _appBar(){
    return AppBar(
      title: Text("Nova tarefa"),
    );
  }


  //Conteúdo
  Widget _body(){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _campoTitulo(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _campoDescricao(),
        )
      ],
    );
  }


  //Campo título
  Widget _campoTitulo(){
    return TextField(
      controller: tituloController,
      decoration: InputDecoration(
          //hintText: "Título",
          icon: Icon(Icons.text_fields),
        labelText: "Título"
      ),
    );
  }


  //Campo descrição
  Widget _campoDescricao(){
    return TextField(
      controller: descricaoController,
      decoration: InputDecoration(
        //hintText: "Descrição",
        icon: Icon(Icons.text_fields),
        labelText: "Descrição"
      ),
    );
  }


  //Botão salvar
  Widget _btnSalvar(){
    return FloatingActionButton(
      tooltip: "salvar",
      child: Icon(Icons.save),
      onPressed: () {

        this.tarefa.titulo = tituloController.text;
        this.tarefa.descricao = descricaoController.text;

        if (this.tarefa.titulo == null || this.tarefa.titulo.isEmpty){
          Toast.show("Por favor, insira o título", context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM
          );
          return;
        }

        if (this.tarefa.descricao == null || this.tarefa.descricao.isEmpty){
          Toast.show("Por favor, insira a descrição", context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM
          );
          return;
        }

        var dao = Dao();
        var retorno = dao.inserir(tarefa);
        retorno.then((r) {
            _fecharTela();
        });

      },
    );
  }


  void _fecharTela(){
    if (Navigator.canPop(context))
      Navigator.pop(context);
    else
      SystemNavigator.pop(); // caso a tela não tenha pai, não recomendado para IOS

    /*Route rota = MaterialPageRoute(builder: (context) => Main());
     Navigator.pushReplacement(context, rota); // termina a tela atual
     Navigator.push(context, rota); // cria uma nova tela sobre a atual*/
  }

}