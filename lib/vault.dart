import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_vault_mobile/functions/items_management.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  _VaultScreenState createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  List<Item> itemList = [];

  @override
  void initState() {
    super.initState();
    initItemList();
  }

  void initItemList() async {
    setState(() async {
      itemList = await getAllItems();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Vault"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(index.toString()),
                    Text(itemList[index].username),
                    Text(itemList[index].password),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {

                    },
                    child: null
                ),
              ],
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addNewItem(Item(username: 'skata', password: 'testpassword'));
          if (kDebugMode) {
            print("Added: " + (await getRecentItem()).toString());
          }
          setState(() {
            initItemList();
          });
        },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
