import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/grocery.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _quantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-test-3724f-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-app.json');

    final response = await  http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'id': DateTime.now().toString(),
            'name': _name,
            'quantity': _quantity,
            'category': _selectedCategory.title,
          }));

          print(response.body);
          print(response.statusCode);

          if(context.mounted){
            return;
          }
          Navigator.of(context).pop();

 
      // Navigator.of(context).pop(GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _name,
      //     quantity: _quantity,x`x`
      //     category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD ITEMS❗"),
      ), 
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: "NAME",
                  labelStyle: TextStyle(fontSize: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error❗ Input is required.";
                  }
                  if (value.length < 2 || value.length > 50) {
                    return "Error❗ Name must be 2-50 characters.";
                  }
                  return null;
                },
                onSaved: (value) => _name = value!, 
              ),
              const SizedBox(height: 18),

              // Row with Quantity and Category with proper cross alignment
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Aligns "Category" text higher
                children: [
                  Expanded(
                    child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Quantity",
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: "1",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Error❗ Quantity required.";
                          }
                          final numValue = int.tryParse(value);
                          if (numValue == null || numValue <= 0) {
                            return "Error❗ Enter a valid quantity.";
                          }
                          return null;
                        },
                        onSaved: (value) => _quantity = int.parse(value!)),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(fontSize: 12),
                        ),
                        DropdownButtonFormField(
                          value: _selectedCategory,
                          items: categories.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: entry.value.color,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(entry.value.title,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      setState(() {
                        _selectedCategory = categories[Categories.vegetables]!;
                      });
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
