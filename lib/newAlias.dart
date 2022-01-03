import 'package:flutter/material.dart';
import 'package:password_vault_mobile/functions/database_management.dart';
import 'package:password_vault_mobile/functions/master_encryption.dart';

class NewAliasScreen extends StatefulWidget {
  const NewAliasScreen({Key? key}) : super(key: key);

  @override
  _NewAliasScreenState createState() => _NewAliasScreenState();
}

class _NewAliasScreenState extends State<NewAliasScreen> {
  final passwordFieldController = TextEditingController();

  void submitButtonPressed() async {
    dropTable('salt');
    dropTable('hash');

    createByteTable('salt');
    createByteTable('hash');

    List<int> newSalt = generateRandomSalt();
    insertIntoByteTable(newSalt, 'salt');
    insertIntoByteTable(await generateHashBytesOf(passwordFieldController.text, newSalt), 'hash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New alias'),
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
                  onPressed: () {
                    submitButtonPressed();
                  },
                  child: const Text("Create"),
                ),
              ],
            )
        ),
      ),
    );
  }
}
