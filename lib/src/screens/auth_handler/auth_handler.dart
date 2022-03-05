import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/screens/login_screen/login_screen.dart';
import 'package:geo_chat_app/src/screens/online_user.dart';
import 'package:geo_chat_app/src/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<AuthService>(context).theUser != null
        ? OnlineUser()
        : LoginScreen();
  }
}
