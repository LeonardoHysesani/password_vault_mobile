import 'package:flutter/material.dart';

import 'functions/items.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key, required this.item, required this.updateItemList, required this.updateItemDisplay}) : super(key: key);
  final Item item;
  final Function() updateItemList;
  final void Function(Item) updateItemDisplay;

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final typeFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final notesFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    typeFieldController.text = widget.item.type;
    usernameFieldController.text = widget.item.username;
    passwordFieldController.text = widget.item.password;
    notesFieldController.text = widget.item.notes;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(onPressed: () {Navigator.pop(context);}, child: const Text('Cancel')),
        ],
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
              labelText: 'Type (i.e. Facebook, Google)',
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
              Item updatedItem = Item(
                id: widget.item.id,
                base64iv: widget.item.base64iv,
                type: typeFieldController.text,
                username: usernameFieldController.text,
                password: passwordFieldController.text,
                notes: notesFieldController.text,
              );
              widget.item.replaceWith(updatedItem);
              widget.updateItemDisplay(updatedItem);
              widget.updateItemList();
              Navigator.pop(context);


              // notify that item has been updated
              const snackBar = SnackBar(
                content: Text('Applied changes'),
                duration: Duration(seconds: 3),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Apply changes'),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
