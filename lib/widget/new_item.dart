import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category_model.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  final formKey=GlobalKey<FormState>();
  var enteredName='';
  var enteredQuantity;

  var _selectedCategory=categories[Categories.vegetables]!;

 void _saveItem(){  //validate is a method provided by the form widget which automtically which reach outs to all the form widgets inside of the form and executes its validator functions 
 if(formKey.currentState!.validate()){// as validate returns bool value we can pass it in if else condition and check if validations are correect only then the data will be saved   
  formKey.currentState!.save();
  Navigator.of(context).pop(GroceryItem(id: DateTime.now.toString(), name: enteredName, quantity: enteredQuantity, category: _selectedCategory));
  }
  
 }
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new item")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key:formKey ,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value){
                  enteredName=value!;
                },
              ), // instead of textfield() widget while dealing with forms
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(label: Text('Quantity')),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number';
                        }
                        return null;
                      },
                      onSaved: (value){
                        enteredQuantity=int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                   
                      items: [
                        for (final category
                            in categories
                                .entries) //.entries is used to treat a map like a list
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory=value!;
                        });
                        
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {
                    formKey.currentState!.reset();
                  }, 
                  child: Text('Reset')),
                  SizedBox(width: 5),
                  ElevatedButton(onPressed: _saveItem,
                   child: Text('Add Items')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
