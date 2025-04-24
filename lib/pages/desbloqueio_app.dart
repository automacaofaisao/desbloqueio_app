import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/auth_service.dart';


class Empresa {
  final String nome;
  final String cnpj;
  final String serial;

  Empresa(this.nome, this.cnpj, this.serial);
}

class DesbloqueioPage extends StatefulWidget {
  @override
  _DesbloqueioPageState createState() => _DesbloqueioPageState();
}

class _DesbloqueioPageState extends State<DesbloqueioPage> {
  final List<Empresa> empresas = [
    Empresa("Posto JR Faisão LTDA", "24829441000169", "00014003750070624"),
    Empresa("Posto JR Faisão IV LTDA", "28624878000117", "00014003750057486"),
    Empresa("Lanchonete Oliveira", "9417530000129", "00014003750057486"),
    Empresa("Posto JR Faisão VII LTDA", "49417530000129", "000140037500574XX"),
  ];

  Empresa? empresaSelecionada;
  final TextEditingController senhaController = TextEditingController();
  final String telefone = "31985360000";

  String? senhaExtraida;
  bool isLoading = false; // 🔄 controle de carregamento

  void desbloquear() async {
    if (empresaSelecionada == null || senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecione uma empresa e digite a senha.")),
      );
      return;
    }

    final uri = Uri.parse("https://f33e-157-173-117-10.ngrok-free.app/desbloquear");

    setState(() {
      isLoading = true; // 🟢 inicia carregamento
      senhaExtraida = null; // limpa resultado anterior
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rsocial': empresaSelecionada!.nome.toUpperCase(),
          'cnpj': empresaSelecionada!.cnpj,
          'serial': empresaSelecionada!.serial,
          'senha': senhaController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          senhaExtraida = data['codigo'] ?? 'Código não encontrado';
        });
      } else {
        setState(() {
          senhaExtraida = 'Erro ao obter código';
        });
      }
    } catch (e) {
      setState(() {
        senhaExtraida = 'Erro de conexão: $e';
      });
    } finally{
      setState(() {
        isLoading = false; // 🔴 encerra carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Desbloqueio de REP"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                    Icons.exit_to_app_outlined, color: Colors.white),
              onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Confirmação'),
                        content: Text("Tem certeza que deseja sair?"),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: (){
                              Get.find<AuthService>().logout();
                              Navigator.of(context).pop();
                            },
                          child: const Text("Sair")),
                        ],
                      );
                    }
                  );

              },
            ),


          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Empresa>(
              hint: Text("Selecione a empresa"),
              isExpanded: true,
              value: empresaSelecionada,
              items: empresas.map((empresa) {
                return DropdownMenuItem(
                  value: empresa,
                  child: Text(empresa.nome),
                );
              }).toList(),
              onChanged: (empresa) {
                setState(() {
                  empresaSelecionada = empresa;
                });
              },
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: "Senha"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : desbloquear,
              child: Text("Desbloquear"),
            ),
            SizedBox(height: 30),
            if (isLoading)
              CircularProgressIndicator() // 🔄 indicador de carregamento
            else if (senhaExtraida != null)
              Text(
                "Código de desbloqueio: $senhaExtraida",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
