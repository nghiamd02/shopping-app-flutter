import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_item.dart';

class Groceries extends StatelessWidget {
  const Groceries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ListView.builder(
            itemCount: groceryItems.length,
            itemBuilder: (ctx, index) => ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: groceryItems[index].category.color,
                  ),
                  title: Text(groceryItems[index].name),
                  trailing: Text('${groceryItems[index].quantity}'),
                )));
  }
}
