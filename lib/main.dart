import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/services/auth_service.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print('initialized'));
  runApp(
    MultiProvider(
      child: const AppView(),
      providers: [
        //ChangeNotifierProvider(create: (context) => TheNameProvider()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
    ),
  );
}
