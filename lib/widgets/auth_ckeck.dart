import 'package:desbloqueio_app/pages/desbloqueio_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/login/inicial_page.dart';
import '../services/auth_service.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Get.find();
    return Obx(() {
      if (auth.isLoading.value ?? false) {
        return loading();
      } else if (auth.usuario == null) {
        return const InicialPage();
      } else {
        // Usuário está autenticado, redirecionar para HomePage
        return DesbloqueioPage();
      }
    });
  }
}

Widget loading() {
  return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}