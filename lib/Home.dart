import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _cepController = TextEditingController();
  var _endereco = "Endereço";
  var _corTextEndereco = Colors.black26;

  _limpar() {
    setState(() {
      _endereco = "Endereço";
      _cepController.text = "";
      _corTextEndereco = Colors.black26;
    });
  }

  _recuperarCep() async {
    Uri url = Uri.parse("https://viacep.com.br/ws/${_cepController.text}/json/");
    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> objeto = json.decode(response.body);

    String cep         = objeto['cep'];
    String logradouro  = objeto['logradouro'];
    String complemento = objeto['complemento'];
    String bairro      = objeto['bairro'];
    String localidade  = objeto['localidade'];
    String uf          = objeto['uf'];
    String ibge        = objeto['ibge'];
    String gia         = objeto['gia'];
    String ddd         = objeto['ddd'];
    String siafi       = objeto['siafi'];

    setState(() {
      _corTextEndereco = Colors.black;

      if(objeto['cep'] == null) {
        print(objeto);
        _endereco = "Endereço não encontrado!";
      } else {
        _endereco = "$logradouro $complemento $bairro $localidade - $uf";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brasil CEP'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 200),
              child: Text(
                _endereco,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: _corTextEndereco,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Digite um CEP (apenas números)',
                ),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
                controller: _cepController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: ElevatedButton(
                onPressed: () {
                  _recuperarCep();
                },
                child: Text('Buscar Cep'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _limpar();
              },
              child: Text('Limpar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black45,
                padding: EdgeInsets.symmetric(horizontal: 125, vertical: 15),
                textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
