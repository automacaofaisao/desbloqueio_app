import "package:firebase_auth/firebase_auth.dart";
//import "package:flutter/material.dart";
import 'package:get/get.dart';

import "../pages/login/inicial_page.dart";


class AuthException implements Exception{
  String message;
  AuthException(this.message);
}

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? usuario;
  RxBool isLoading = false.obs;
  RxInt tentativas = 5.obs;

  AuthService() {
    isLoading.value = false;
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      isLoading.value = false; // Set it to false by default
      if (user != null) {
        usuario = user;
      }

    });
  }

  _getUser() {
    usuario = _auth.currentUser;
  }



  login(String email, String senha) async {
    try {
      print(email);
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se!');
      } else if (e.code == 'wrong-password') {
        if (tentativas.value > 1) {
          tentativas.value--;
          throw AuthException(
              'Senha incorreta. Você tem ${tentativas.value} tentativas!');
        } else {
          throw AuthException(
              'Usuário bloqueado! Entre em contato com o administrador para desbloquear!');
        }
      } else if (e.code == 'too-many-requests') {
        throw AuthException(
            'Usuário bloqueado! Aguarde alguns minutos e tente novamente!');
      }else if (e.code == 'user-disabled') {
        throw AuthException(
            'Usuário bloqueado no servidor de autenticação! Entre em contato com o administrador!');
      }
      else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido');
      } else {
        throw AuthException(e.code.toString());
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
    usuario = null;
    Get.offAll(()=>const InicialPage());

    //Get.off(() => const InicialPage());
  }

  String? obterEmailUsuarioLogado() {
    if (usuario != null) {
      return usuario?.email;
    } else {
      return '';
    }
  }

  String obterUidLogado() {
    _getUser();
    if (usuario != null) {
      String userId = usuario!.uid;

      return userId;
    } else {
      return '';
    }
  }

}