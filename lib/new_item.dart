import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

import 'functions/items.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({Key? key, required this.updateItemList, required this.id}) : super(key: key);
  final int id;
  final Function() updateItemList;
  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final typeFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final notesFieldController = TextEditingController();

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
              labelText: '* Type (i.e. Facebook, Google)'
            ),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: usernameFieldController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '* Username'
            ),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: passwordFieldController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '* Password'
            ),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: notesFieldController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Notes'
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (typeFieldController.text != ''
              && usernameFieldController.text != ''
              && passwordFieldController.text != '') {
                Item newItem = Item(
                  id: widget.id,
                  base64iv: encrypt.IV.fromSecureRandom(16).base64,
                  type: typeFieldController.text,
                  username: usernameFieldController.text,
                  password: passwordFieldController.text,
                  notes: notesFieldController.text,
                );
                newItem.add();
                widget.updateItemList();
                Navigator.pop(context);
              }
              else {
                // notify to fill required fields
                const snackBar = SnackBar(
                  content: Text('Please fill in all fields with an asterisk (*)'),
                  duration: Duration(seconds: 3),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('Save'),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
