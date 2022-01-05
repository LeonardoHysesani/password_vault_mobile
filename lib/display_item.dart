import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault_mobile/edit_item.dart';

import 'functions/items.dart';

class DisplayItemScreen extends StatefulWidget {
  const DisplayItemScreen({Key? key, required this.item, required this.updateItemList}) : super(key: key);
  final Item item;
  final Function() updateItemList;

  @override
  _DisplayItemScreenState createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends State<DisplayItemScreen> {
  bool intendToDelete = false;
  late Item currentItem;
  @override
  void initState() {
    super.initState();
    currentItem = widget.item;
  }
  void updateItemDisplay(Item updatedItem) {
    setState(() {
      currentItem = updatedItem;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem.type),
      ),
      body: Center(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Center(child: Text('Username', style: TextStyle(fontSize: 20, color: Colors.grey),),),
                    Card(
                      child: Text(currentItem.username, style: const TextStyle(fontSize: 28),),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: currentItem.username));

                          // notify that username has been copied to clipboard
                          const snackBar = SnackBar(
                            content: Text('Username copied to clipboard'),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.copy, color: Colors.blue,),
                        iconSize: 36,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 10,),
                Column(
                  children: [
                    const Center(child: Text('Password', style: TextStyle(fontSize: 20, color: Colors.grey),),),
                    Card(
                      child: Text(currentItem.password, style: const TextStyle(fontSize: 28),),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: currentItem.password));

                          // notify that password has been copied to clipboard
                          const snackBar = SnackBar(
                            content: Text('Password copied to clipboard'),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.copy, color: Colors.blue,),
                        iconSize: 36,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 10,),
                if (currentItem.notes != '')
                  Column(
                    children: [
                      const Center(child: Text('Notes', style: TextStyle(fontSize: 20, color: Colors.grey),),),
                      Card(
                        child: Text(currentItem.notes, style: const TextStyle(fontSize: 16),),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 30,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'deleteButton',
              onPressed: () {
                setState(() {
                  intendToDelete = true;
                });
              },
              child: const Icon(Icons.delete, color: Colors.white,),
              backgroundColor: Colors.red,
            ),
          ),
          Positioned(
            right: 30,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'editButton',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EditItemScreen(
                          item: currentItem,
                          updateItemList: widget.updateItemList,
                          updateItemDisplay: updateItemDisplay,
                        );
                      }
                    )
                );
              },
              child: const Icon(Icons.edit, color: Colors.white,),
              backgroundColor: Colors.blue,
            ),
          ),
          if (intendToDelete)
            DeleteDialog(
              content: 'Do you want to delete this item?',
              deleteCallBack: () {
                currentItem.delete();
                widget.updateItemList();
                Navigator.pop(context);

                // notify that item has been deleted
                const snackBar = SnackBar(
                  content: Text('Deleted'),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              cancelCallBack: () {
                  setState(() {
                    intendToDelete = false;
                  });
                }
            ),
        ],
      ),
    );
  }
}


class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key,required this.content,required this.deleteCallBack,required this.cancelCallBack}) : super(key: key);

  final String content;
  final VoidCallback deleteCallBack;
  final VoidCallback cancelCallBack;

  final TextStyle textStyle = const TextStyle (color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          content: Text(content, style: textStyle,),
          actions: <Widget>[
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.white),),
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                deleteCallBack();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                cancelCallBack();
              },
            ),
          ],
        )
    );
  }
}

