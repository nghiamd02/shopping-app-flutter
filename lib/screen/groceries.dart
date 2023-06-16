import 'package:flutter/material.dart';
import 'package:shopping_app/model/grocery_item.dart';
import 'package:shopping_app/screen/add_grocery.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  final List<GroceryItem> _groceries = [];

  void _onAddBtnPressed() async {
    final GroceryItem newGrocery = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewGrocery()));
    setState(() {
      _groceries.add(newGrocery);
    });
  }

  void _onRemove(GroceryItem item) {
    setState(() {
      _groceries.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Not any grocery!'),
    );
    if (_groceries.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceries.length,
          itemBuilder: (ctx, index) => Dismissible(
                onDismissed: (direction) => _onRemove(_groceries[index]),
                key: ValueKey(_groceries[index].id),
                child: ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: _groceries[index].category.color,
                  ),
                  title: Text(_groceries[index].name),
                  trailing: Text('${_groceries[index].quantity}'),
                ),
              ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _onAddBtnPressed, icon: const Icon(Icons.add))
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: content);
  }
}
