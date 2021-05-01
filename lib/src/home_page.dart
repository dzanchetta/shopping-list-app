import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _items = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: _createList(),
      floatingActionButton: _createButtons(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40.0,
        ),
        color: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _createList() {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return _createListItem(_items[index], index);
        });
  }

  Future<String> _showInputModal(BuildContext context) {
    TextEditingController _itemToAdd = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Add new Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _createTextField(_itemToAdd),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_itemToAdd.text.toString()),
                    child: Text('Save & Close'))
              ],
            ),
        barrierDismissible: false);
  }

  Widget _createTextField(TextEditingController _itemToAdd) {
    return TextField(
      controller: _itemToAdd,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 20,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: 'List item name',
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _createButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 80.0,
        ),
        FloatingActionButton(
          child: Icon(Icons.add_shopping_cart),
          backgroundColor: Colors.green,
          onPressed: () => _showInputModal(context).then((value) {
            if (value.isNotEmpty) {
              setState(() {
                _items.add(value);
              });
            }
          }),
        ),
        Expanded(child: SizedBox()),
        FloatingActionButton(
          child: Icon(Icons.remove_shopping_cart),
          backgroundColor: Colors.red,
          onPressed: () {
            setState(() {
              _items.clear();
            });
          },
        ),
        SizedBox(
          width: 80.0,
        )
      ],
    );
  }

  Widget _createListItem(String item, int index) {
    //Improvement: apply Dismissible class (https://www.youtube.com/watch?v=iEMgjrfuc58)
    final int indexToSubtitle = index + 1;
    return Card(
      elevation: 10.0,
      child: ListTile(
        leading: Icon(Icons.label_important_sharp),
        title: Text(
          item,
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: Text("Item #$indexToSubtitle"),
        trailing: IconButton(
          icon: Icon(Icons.highlight_remove_sharp),
          iconSize: 28.0,
          onPressed: () {
            setState(() {
              _items.removeAt(index);
            });
          },
        ),
      ),
    );
  }
}
