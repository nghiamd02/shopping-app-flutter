import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/data/categories_data.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/grocery_item.dart';
import 'package:shopping_app/screen/add_grocery.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  List<GroceryItem> _groceries = [];
  var _isLoading = true;
  String? _error;

  //Load data from database
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _onAddBtnPressed() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewGrocery()));
    setState(() {
      _groceries.add(newItem);
    });
  }

  void _loadData() async {
    //get data by using get method
    final url =
        Uri.https('dummy-prep-default-rtdb.firebaseio.com', 'new-item.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Errors happened, please try again later!';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    //convert json to Map
    Map<String, dynamic> dataList = json.decode(response.body);

    //add data to a temporary list then reassign to the my groceries
    List<GroceryItem> tempList = [];
    for (final item in dataList.entries) {
      //Filter the category by type of category
      final category = categories.entries
          .firstWhere((element) => element.value.type == item.value['category'])
          .value;
      tempList.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }

    setState(() {
      _groceries = tempList;
      _isLoading = false;
    });
  }

  void _onRemove(GroceryItem item) async {
    final index = _groceries.indexOf(item);

    setState(() {
      _groceries.remove(item);
    });
    final url = Uri.https(
        'dummy-prep-default-rtdb.firebaseio.com', 'new-item/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      if (!context.mounted) {
        return;
      }
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Remove unsuccessfully'),
              content: const Text(
                  'You cannot remove the item, please try again later'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'))
              ],
            );
          });
      setState(() {
        _groceries.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Not any grocery!'),
    );

    //During the fetching time, screen is a circular progress
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    // If any errors exist
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    if (_groceries.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceries.length,
          itemBuilder: (ctx, index) => Dismissible(
                //remove item whenever we slide the item to the side
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
