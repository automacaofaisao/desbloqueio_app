import 'package:desbloqueio_app/pages/desbloqueio_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../styles/button_style.dart';


class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final AuthService authService = Get.find<AuthService>();

  bool _obscureText = true;

  void enviarMsgSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> login() async {
    if (email.text.isEmpty || senha.text.isEmpty) {
      enviarMsgSnackbar('É necessário preencher o campo email e senha corretamente!');
      return;
    }

    try {
      await authService.login(email.text, senha.text);
      if (authService.usuario != null) {

        Get.off(() => DesbloqueioPage()); // Navegar para a HomePage (DesbloqueioPage)

      }
    } catch (e) {
      enviarMsgSnackbar('Erro ao fazer login: ${e.toString()}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white54,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Image.asset("assets/iconeinicial.png", width: 150, height: 150),
                const SizedBox(height: 24),
                const Text(
                  "App Desbloqueio de REP",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: senha,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: MyButtonStyle.elevatedButtonStyle(),
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}