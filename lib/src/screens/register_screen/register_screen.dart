import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/constants/style.dart';
import 'package:geo_chat_app/src/services/auth_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? username;
  String? email;
  String? password;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var location = Location();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registeration'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
                child: Column(
              children: [
                //user name
                TextFormField(
                  controller: _userNameController,
                  keyboardType: TextInputType.name,
                  decoration: generalInputDecoration(
                      labelText: 'Username', hintText: 'eg/ Muhammad'),
                ),
                //passsword

                SizedBox(height: 15),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: generalInputDecoration(
                      labelText: 'email', hintText: 'eg/ Muhammad@gmail.com'),
                ),

                SizedBox(height: 15),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: generalInputDecoration(labelText: 'Password'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var serviceEnabled = await location.serviceEnabled();
                    if (!serviceEnabled) {
                      serviceEnabled = await location.requestService();
                      if (!serviceEnabled) {
                        return;
                      }
                    }
                    var permissionGranted = await location.hasPermission();
                    if (permissionGranted == PermissionStatus.denied) {
                      permissionGranted = await location.requestPermission();
                      if (permissionGranted != PermissionStatus.granted) {
                        return;
                      }
                    }

                    setState(() {
                      username = _userNameController.value.text;
                      email = _emailController.value.text;
                      password = _passwordController.value.text;
                    });
                    var currentLocation = await location.getLocation();
                    email = email!.trim(); //remove spaces
                    email = email!.toLowerCase(); //convert to lowercase
                    await Provider.of<AuthService>(context, listen: false)
                        .registerWithEmailAndPassword(email!, password!);
                    User? user = FirebaseAuth.instance.currentUser;
                    await firestore.collection('users').doc(user!.uid).set({
                      "username": username,
                      "lat": currentLocation.latitude,
                      "lng": currentLocation.longitude
                    });
                    //Navigator.pop(context); //pop the current screen
                  },
                  icon: Icon(
                    Icons.login,
                  ),
                  label: Text('Sign up'),
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
                SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/privacyPolicyScreen');
                    },
                    child: Text('Privacy Policy')),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
