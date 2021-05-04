import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
String sharedPreferencesKey = "shopping_list";
//List<String> _itemsToShow = <String>[];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
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
          retrieveItems();
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
                saveItem(_items);
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
              //_items.clear();
              _items.clear();
              saveItem(_items);
            });
          },
        ),
        SizedBox(
          width: 80.0,
        )
      ],
    );
  }

  saveItem(List<String> item) async {
    await HomePage.init();
    prefs.setStringList(sharedPreferencesKey, item);
  }

  retrieveItems() async {
    await HomePage.init();
    _items = prefs.getStringList(sharedPreferencesKey) ?? [];
  }

  Widget _createListItem(String item, int index) {
    final int indexToSubtitle = index + 1;
    return Dismissible(
      child: Card(
        elevation: 10.0,
        child: ListTile(
          leading: Icon(Icons.label_important_sharp),
          title: Text(
            item,
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: Text("Item #$indexToSubtitle"),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _items.removeAt(index);
          saveItem(_items);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$item deleted!"),
          duration: Duration(seconds: 1),
        ));
      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(Icons.delete, size: 30.0),
      ),
      key: Key(item),
    );
  }
}
