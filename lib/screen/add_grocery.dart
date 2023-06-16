import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories_data.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/grocery_item.dart';

class NewGrocery extends StatefulWidget {
  const NewGrocery({super.key});
  @override
  State<NewGrocery> createState() {
    return _NewGroceryState();
  }
}

class _NewGroceryState extends State<NewGrocery> {
  final _formKey = GlobalKey<FormState>();
  var _inputName = '';
  var _inputQuantity = 1;
  var _initCategory = categories[Categories.fruit];

  void _onFormSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _inputName,
          quantity: _inputQuantity,
          category: _initCategory!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new grocery'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(label: Text('Name')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Must be more than 1 and less than 50 characters";
                }
                return null;
              },
              onSaved: (value) {
                _inputName = value!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text('Quantity')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return "Must be more than 0";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _inputQuantity = int.parse(value!);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownButtonFormField(
                        value: _initCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(category.value.type),
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _initCategory = value;
                          });
                        })),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _onFormSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    'Add Item',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
