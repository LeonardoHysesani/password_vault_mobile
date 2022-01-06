import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault_mobile/display_item.dart';
import 'package:password_vault_mobile/functions/items.dart';
import 'package:password_vault_mobile/main.dart';
import 'package:password_vault_mobile/new_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  _VaultScreenState createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  late List<Item> itemList;
  bool intendToSearch = false;

  @override
  void initState() {
    super.initState();
    itemList = [];
    updateItemList();
  }

  void updateItemList() async {
    itemList = await getAllItems();
    setState(() {
      itemList;
    });
  }

  int generateNextId(List<Item> itemList) {
    // Assign an initial id of 1 if this is the lists first element
    // Or
    // Increment the last items index to avoid id collisions
    return itemList.isEmpty ? 1 : itemList.last.id + 1;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Vault"),
        automaticallyImplyLeading: false,
        actions: [
          /*
          IconButton(
              onPressed: () {
                setState(() {
                  intendToSearch = !intendToSearch;
                });
              },
              icon: const Icon(Icons.search)
          ),

           */
          //IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const AuthenticationScreen();}));
              },
              icon: const Icon(Icons.logout,),
            color: Colors.red,
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
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(itemList[index].type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(itemList[index].username, style: const TextStyle(fontSize: 16),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: itemList[index].username));

                              // notify that username has been copied to clipboard
                              const snackBar = SnackBar(
                                content: Text('Username copied to clipboard'),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            icon: const Icon(Icons.account_circle, color: Colors.blue,)
                        ),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: itemList[index].password));

                              // notify that password has been copied to clipboard
                              const snackBar = SnackBar(
                                content: Text('Password copied to clipboard'),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            icon: const Icon(Icons.lock, color: Colors.blue,)
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {return DisplayItemScreen(item: itemList[index], updateItemList: updateItemList,);}));
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return NewItemScreen(
                      id: generateNextId(itemList),
                      updateItemList: updateItemList,
                    );
                  }
                  )
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
