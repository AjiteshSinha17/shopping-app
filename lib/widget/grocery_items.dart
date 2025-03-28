import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/model/grocery.dart';
import 'package:shopping_app/widget/user_input.dart';
import 'package:http/http.dart' as http;

class ItemsMain extends StatefulWidget {
  const ItemsMain({
    super.key,
  });

  @override
  State<ItemsMain> createState() => _ItemsMainState();
}

class _ItemsMainState extends State<ItemsMain> {
  List<GroceryItem> _groceryitems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-test-3724f-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-app.json');
    final response = await http.get(url);
    final Map<String, dynamic> listdata = json.decode(response.body);

    final List<GroceryItem> loadItems = [];

    for (final item in listdata.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;

      loadItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    _groceryitems = loadItems;
  }

  void _addItem() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));
  }

  void _removeitems(GroceryItem item) {
    setState(() {
      _groceryitems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Groceries❗",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold)),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: _groceryitems.isNotEmpty
            ? ListView.builder(
                itemCount: _groceryitems.length,
                itemBuilder: (ctx, index) => Dismissible(
                      onDismissed: (direction) {
                        _removeitems(_groceryitems[index]);
                      },
                      key: ValueKey(_groceryitems[index].id),
                      child: ListTile(
                        title: Text(_groceryitems[index].name),
                        leading: Container(
                          width: 24,
                          height: 24,
                          color: _groceryitems[index].category.color,
                        ),
                        trailing:
                            Text(_groceryitems[index].quantity.toString()),
                      ),
                    ))
            : Center(
                child: Text("NO Item"),
              ));
  }
}
