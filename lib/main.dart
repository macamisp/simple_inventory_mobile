import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final int quantity;

  Item({required this.id, required this.name, required this.price, required this.quantity});
}

class Inventory {
  final List<Item> _items = [];
  int _nextId = 1;

  void addItem(String name, double price, int quantity) {
    if (name.isEmpty || quantity <= 0) {
      return; // or handle error
    }
    final item = Item(id: _nextId++, name: name, price: price, quantity: quantity);
    _items.add(item);
  }

  void updateItem(int id, String name, double price, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = Item(id: id, name: name, price: price, quantity: quantity);
    }
  }

  void deleteItem(int id) {
    _items.removeWhere((item) => item.id == id);
  }

  List<Item> get items => List.unmodifiable(_items);
}

class InventoryApp extends StatefulWidget {
  @override
  _InventoryAppState createState() => _InventoryAppState();
}

class _InventoryAppState extends State<InventoryApp> {
  final Inventory _inventory = Inventory();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showEditDialog(Item item) {
    _nameController.text = item.name;
    _priceController.text = item.price.toString();
    _quantityController.text = item.quantity.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: TextStyle(color: Colors.teal),
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Item Price',
                labelStyle: TextStyle(color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Item Quantity',
                labelStyle: TextStyle(color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text;
              final price = double.tryParse(_priceController.text) ?? 0.0;
              final quantity = int.tryParse(_quantityController.text) ?? 0;
              setState(() {
                _inventory.updateItem(item.id, name, price, quantity);
              });
              Navigator.pop(context);
              _nameController.clear();
              _priceController.clear();
              _quantityController.clear();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory System'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: TextStyle(color: Colors.teal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Item Price',
                labelStyle: TextStyle(color: Colors.teal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Item Quantity',
                labelStyle: TextStyle(color: Colors.teal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0.0;
                final quantity = int.tryParse(_quantityController.text) ?? 0;
                setState(() {
                  _inventory.addItem(name, price, quantity);
                });
                _nameController.clear();
                _priceController.clear();
                _quantityController.clear();
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: _inventory.items.length,
                  itemBuilder: (context, index) {
                    final item = _inventory.items[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            color: Colors.teal[50],
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text('Price: LKR ${item.price.toStringAsFixed(2)}\nQuantity: ${item.quantity} kg'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.teal),
                                    onPressed: () => _showEditDialog(item),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _inventory.deleteItem(item.id);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InventoryApp(),
    debugShowCheckedModeBanner: false,
  ));
}
