import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/screens/auth_handler/auth_handler.dart';
import 'package:geo_chat_app/src/screens/login_screen/login_screen.dart';
import 'package:geo_chat_app/src/screens/online_user.dart';
import 'package:geo_chat_app/src/screens/register_screen/register_screen.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);
  final String selectedLang = 'ar';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.red,
          textTheme: TextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red,
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthHandler(), //this was the Auth handler
        '/onlineUser': (context) => OnlineUser(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
