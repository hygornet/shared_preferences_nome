import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nomeController = TextEditingController();
  String nome = "";
  String saudacoes = "";

  salvarNome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("nome", nomeController.text);
    });
  }

  Future<String> exibirNome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    nome = sharedPreferences.getString("nome") ?? 'usuário';
    return nome;
  }

  limpar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.clear();
      nomeController.text = "";
    });
  }

  bool containName() {
    if (nome != "usuário") {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    var time = DateTime.now().hour;

    saudacoesUser(time);
    // saudacoesU();

    exibirNome().then((name) {
      setState(() {
        nome = name;
      });
    });
  }

  // saudacoesU() {
  //   TimeOfDay day = TimeOfDay.now();
  //   switch (day.period) {
  //     case DayPeriod.am:
  //       saudacoes = 'Bom dia!';
  //       break;
  //     case DayPeriod.pm:
  //       saudacoes = 'Boa tarde!';
  //       break;
  //   }
  // }

  String saudacoesUser(int time) {
    if (time <= 12) {
      return saudacoes = 'Bom dia!';
    } else if ((time > 12) && (time <= 16)) {
      return saudacoes = 'Boa tarde!';
    } else if ((time > 16) && (time < 20)) {
      return saudacoes = 'Boa noite!';
    } else {
      return saudacoes = 'Boa noite!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Olá, $nome! Seja bem vindo. $saudacoes'),
                  containName()
                      ? Text('Entre com o seu nome logo abaixo! :)')
                      : Container(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          containName()
              ? Container(
                  width: 300,
                  child: _textFormField(),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              containName()
                  ? _button(
                      () async {
                        salvarNome();
                        exibirNome();
                      },
                      Text('SALVAR'),
                    )
                  : Container(),
              SizedBox(width: 10),
              _button(
                () async {
                  limpar();
                  exibirNome();
                },
                Text('LIMPAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _button(Function() onSubmit, Widget text) {
    return TextButton(
      onPressed: onSubmit,
      child: text,
    );
  }

  _textFormField() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: nomeController,
      decoration: InputDecoration(
        hintText: 'Digite seu nome',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
