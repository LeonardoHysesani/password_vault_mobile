import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault_mobile/new_alias.dart';
import 'package:password_vault_mobile/vault.dart';

import 'functions/database_management.dart';
import 'functions/master_encryption.dart';

late String plainPassword;

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

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    dbSetup(setupMasterPassword);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void setupMasterPassword() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const NewAliasScreen();}));
  }

  void submitButtonPressed() async {
    // Authenticate
    bool authenticated = await authenticate(passwordFieldController.text);

    if (kDebugMode) {
      print("Authentication result: " + authenticated.toString());
    }

    // Entrance for successful login attempt
    if (authenticated) {
      plainPassword = passwordFieldController.text;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const VaultScreen();}));
    }
    // Snackbar for failed login attempt
    else {
      const snackBar = SnackBar(
        content: Text('Wrong password'),
        duration: Duration(seconds: 3),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Vault Mobile'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: passwordFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (passwordFieldController.text != '') {
                    submitButtonPressed();
                  }
                },
                child: const Text("Login"),
              ),
              /*
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return const NewAliasScreen();}));
                },
                child: const Text("Delete this alias and create a new one"),
              ),

               */
            ],
          )
        ),
      ),
    );
  }
}

