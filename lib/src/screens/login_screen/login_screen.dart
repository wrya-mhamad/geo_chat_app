import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = 'user name';
  String? password;
  String? theLoggedInUser;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text('Welcome $name'),
              Form(
                  child: Column(
                children: [
                  //user name
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _userNameController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  //passsword

                  SizedBox(height: 15),

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),

                  SizedBox(
                    height: 150,
                  ),

                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        name = _userNameController.value.text;
                        password = _passwordController.value.text;
                      });
                      name = name.trim(); //remove spaces
                      name = name.toLowerCase(); //convert to lowercase

                      await Provider.of<AuthService>(context, listen: false)
                          .loginWithEmailAndPassword(name, password!)
                          .then((value) {
                        setState(() {
                          theLoggedInUser = value!.user!.uid;
                        });
                        Navigator.pushNamed(context, '/onlineUser');
                      });
                    },
                    icon: Icon(
                      Icons.login,
                    ),
                    label: Text(
                      'Login',
                    ),
                  ),

                  //error
                  Provider.of<AuthService>(context).theError == null
                      ? Container()
                      : Container(
                          child: Text(
                            Provider.of<AuthService>(context).theError!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('create account'),
                    style: TextButton.styleFrom(primary: Colors.deepPurple),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
