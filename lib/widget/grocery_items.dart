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
  List<GroceryItem> groceryitems = [];
  var _isloading = true;
  String? _error;

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

    if (response.statusCode >= 400) {
      setState(() {
        _error = "Failed to load. Try Again!";
      });
      return;
    }

    if (response.body == 'null') {
      setState(() {
        _isloading = false;
      });
      return;
    }

    if (response.body.isEmpty) {
      setState(() {
        _error = "No data found!";
        _isloading = false;
      });
      return;
    }

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
    setState(() {
      groceryitems = loadItems;
      _isloading = false;
    });
  }

  Widget content = Center(child: Text("NO Item"));

  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      groceryitems.add(newItem);
    });
  }

  void _removeitems(GroceryItem item) {
    final url = Uri.https(
        'flutter-test-3724f-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-app/${item.id}.json');

    http.delete(url);
    setState(() {
      groceryitems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_isloading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(child: Text(_error!));
    } else if (groceryitems.isEmpty) {
      content = const Center(child: Text("No Items"));
    } else {
      content = ListView.builder(
        itemCount: groceryitems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeitems(groceryitems[index]);
          },
          key: ValueKey(groceryitems[index].id),
          child: ListTile(
            title: Text(groceryitems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryitems[index].category.color,
            ),
            trailing: Text(groceryitems[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Groceries❗",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
    ;
  }
}
