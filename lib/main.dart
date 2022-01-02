import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt; // For items
import 'package:cryptography/cryptography.dart';
import 'package:password_vault_mobile/vault.dart'; // For master

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      title: 'Password Vault Mobile',
      home: const AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  final passwordFieldController = TextEditingController();
  String authStatus = "Log in";

  @override
  void initState() {
    super.initState();
  }




  Future<List<int>> getHashBytesOf(String plaintext) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    // Password we want to hash
    final secretKey = SecretKey(utf8.encode(plaintext));

    // A random salt
    final nonce = [4,5,6];

    // Calculate a hash that can be stored in the database
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    if (kDebugMode) {
      print("Hash bytes : " + newSecretKeyBytes.toString());
    }

    return newSecretKeyBytes;
  }

  Future<bool> authenticate(String password) async {
    bool areEqual = true;
    List<int> bytes1 = await getHashBytesOf("bitch");
    List<int> bytes2 = await getHashBytesOf(password);
    int i = 0;
    while (i < bytes1.length && areEqual) {
      if (bytes1[i] != bytes2[i]) {
        areEqual = false;
      }
      i++;
    }
    setState(() {
      authStatus = areEqual.toString();
    });
    return areEqual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: passwordFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool login = await authenticate(passwordFieldController.text);
                    if (kDebugMode) {
                        print(login.toString());
                    }
                    if (login) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) { return const VaultScreen();}));
                    }
                  },
                  child: const Text("Compare"),
              ),
              Text(authStatus),
              /*
              FutureBuilder(
                future: getHashBytesOf("bitch"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    return Text(getHashBytesOf("bitch").toString());
                  }
                  else {
                    return const Text("Something went wrong with the generatehash() Future");
                  }
                },
              ),
              */
            ],
          )
        ),
      ),
    );
  }
}

