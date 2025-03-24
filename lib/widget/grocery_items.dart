import 'package:flutter/material.dart';
import 'package:shopping_app/model/grocery.dart';
import 'package:shopping_app/widget/user_input.dart';

class ItemsMain extends StatefulWidget {
  const ItemsMain({
    super.key,
  });

  @override
  State<ItemsMain> createState() => _ItemsMainState();
}


class _ItemsMainState extends State<ItemsMain> {

final List<GroceryItem> _groceryitems = [] ;

  void _addItem()async{
   final newItem = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewItem()));

 if(newItem == null){
  return;
}

_groceryitems.add(newItem);
 } 

void _removeitems(GroceryItem item){
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
        body: 
        _groceryitems.isNotEmpty
   ?  
    ListView.builder(
            itemCount: _groceryitems.length,
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction){
                  _removeitems(_groceryitems[index]) ;
              },
              key: ValueKey(_groceryitems[index].id),
              child: ListTile(
                    title: Text(_groceryitems[index].name),
                    leading: Container(
                      width: 24,
                      height: 24,
                      color: _groceryitems[index].category.color,
                    ),
                    trailing: Text(_groceryitems[index].quantity.toString()),
                  ),
            ))

   : Center(child: Text("NO Item"),)

   );
  }
}
