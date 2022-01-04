import 'package:flutter/material.dart';
import 'package:password_vault_mobile/functions/items_management.dart';
import 'package:password_vault_mobile/main.dart';
import 'package:password_vault_mobile/new_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  _VaultScreenState createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  List<Item> itemList = [];
  bool intendToSearch = false;

  @override
  void initState() {
    super.initState();
    updateItemList();
  }

  void updateItemList() async {
    itemList = await getAllItems();
    setState(() {
      itemList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Vault"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  intendToSearch = !intendToSearch;
                });
              },
              icon: const Icon(Icons.search)
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const AuthenticationScreen();}));
              },
              icon: const Icon(Icons.logout)
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          if (intendToSearch)
            Row(
              children: const [
                Expanded(
                  child: TextField(
                    controller: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search by type or username',
                    ),
                  ),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("ID : " + itemList[index].id.toString(), style: const TextStyle(fontSize: 18),),
                              Text(" " + itemList[index].type + " : " + itemList[index].username, style: const TextStyle(fontSize: 20),),
                              //Text("Password : " + itemList[index].password, style: const TextStyle(fontSize: 18),),
                              //Text("IV : " + itemList[index].base64iv, style: const TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.lock)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                      ],
                    )
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {return NewItemScreen(updateItemList: updateItemList,);}));
          /*
          Item newItem = Item(type: 'Google', username: 'skata', password: 'testpassword', base64iv: encrypt.IV.fromSecureRandom(16).base64);
          newItem.add();
          setState(() {
            updateItemList();
          });

           */
        },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
