import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';
import 'package:shopping_list_app/widget/new_item.dart';
import 'package:http/http.dart' as http;
// main screen

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
  var _isLoading=true;
   String? _error;
  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {// method to fetch the data 
    final url = Uri.https(
      'flutter-prep-5fe04-default-rtdb.firebaseio.com',
      'shopping_list_app.json',
    );

    try{
  final response = await http.get(url);
   if(response.statusCode>=400)
    {
      setState(() {
         _error='Failed to fetch data ...';
      });
     
    }


    if(response.body=='null'){
      setState(() {
         _isLoading=false;
      });
     
      return;
    }
    final Map<String, dynamic> listData = json.decode(
      response.body,
    );
    final List<GroceryItem> loadeditems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;
      loadeditems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems=loadeditems;
      _isLoading=false;
    });
    }catch(error){
    setState(() {
         _error='Something went wrong';
      });
     
    }


    
   
  }

  void _additem() async {
    final newItem=await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) => const NewItem()),
    );
    if(newItem==null){
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
  final url = Uri.https(
    'flutter-prep-5fe04-default-rtdb.firebaseio.com',
    'shopping_list_app/${item.id}.json',
  );

  final response = await http.delete(url);

  if (response.statusCode >= 400) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to delete item from backend.')),
    );
    return;
  }

  setState(() {
    _groceryItems.remove(item);
  });
}


  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items  added yet'));

    if(_isLoading==true){
      content=Center(child: CircularProgressIndicator(),);
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );

    }
    if(_error!=null){
           content =  Center(child: Text(_error!));

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _additem, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
