import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

import 'functions/items_management.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({Key? key, required this.updateItemList}) : super(key: key);
  final Function() updateItemList;
  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final typeFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Spacer(),
          TextField(
            controller: typeFieldController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Type'
            ),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: usernameFieldController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username'
            ),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: passwordFieldController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password'
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Item newItem = Item(
                  type: typeFieldController.text,
                  username: usernameFieldController.text,
                  password: passwordFieldController.text,
                  base64iv: encrypt.IV.fromSecureRandom(16).base64
              );
              newItem.add();
              widget.updateItemList();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
