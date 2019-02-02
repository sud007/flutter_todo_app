import 'package:flutter/material.dart';
import 'package:flutter_notodo/model/todo_item.dart';
import 'package:flutter_notodo/utils/database_client.dart';
import 'package:flutter_notodo/utils/date_util.dart';
import 'package:flutter_notodo/ui/widgets/row_item_divider.dart';
import 'package:flutter_notodo/ui/widgets/row_item_finished.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final _textEditController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ItemTodo> _itemList = <ItemTodo>[];
  static const int IS_HEADER = -1;
  static const int IS_FINISH = -2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Flexible(child: _getParent())],
      ),

      //FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _prepareAddDialog,
        backgroundColor: Colors.red,
        tooltip: 'Add',
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  ///This chooses what the main Child view should be.
  ///If list has no items then shows a message in the screen center.
  StatelessWidget _getParent() {
    if (_itemList.length == 0) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: RowItemFinished(),
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: false,
          itemCount: _itemList.length,
          itemBuilder: (_, int index) {
            return _getRowItem(index);
          });
    }
  }

  ///Decides which row item should be inflated in the view.
  ///this is based on the isDone value of each item
  ///-1 = Completed items header
  ///-2 = No Items view
  ///else Row Items CardView
  StatelessWidget _getRowItem(int index) {
    ItemTodo item = _itemList[index];

    if (item.isDone == IS_HEADER) {
      //just the separating layout
      return RowHeader();
    } else if (item.isDone == IS_FINISH) {
      return RowItemFinished();
    } else {
      return Card(
        color: Colors.white10,
        child: ListTile(
          title: _itemList[index],
          onLongPress: () => _prepareEditItem(_itemList[index], index),
          trailing: _getTrailingForListItem(index),
        ),
      );
    }
  }

  ///Decide if delete action or Mark as checked item.
  Listener _getTrailingForListItem(int index) {
    ItemTodo item = _itemList[index];
    if (item.isDone == 0) {
      return Listener(
        key: Key(item.itemName),
        child: Icon(
          Icons.check_circle,
          color: Colors.white30,
        ),
        onPointerDown: (pointerEvent) => _marItemAsDone(item, index),
      );
    } else {
      return Listener(
        key: Key(item.itemName),
        child: Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
        onPointerDown: (pointerEvent) => _deleteItem(item, index),
      );
    }
  }

  ///Shows a dialog for item to add
  void _prepareAddDialog() {
    _textEditController.text = '';

    var alert = new AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'I have to...',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Add title here',
                hintStyle: TextStyle(color: Colors.black12),
                helperText: 'What do you plan to do?',
                helperStyle: TextStyle(color: Colors.black45),
                icon: Icon(
                  Icons.note_add,
                  color: Colors.black45,
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ))),
            cursorColor: Colors.black,
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleAddItem(_textEditController.text);
              _textEditController.clear();
            },
            child: Text('SAVE')),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  ///Handles the Add Item flow
  void _handleAddItem(String text) async {
    ItemTodo item = new ItemTodo(text, dateFormatted(), dateFormatted());

    //save in DB
    int saveId = await db.saveItem(item);

    //close dialog
    Navigator.pop(context);

    _readNoDoList();

    print('item ${item.itemName} status ${item.isDone}');
    print('item saved id $saveId');
  }

  ///THis code refreshes the list everytime DB has some change in the data.
  ///refreshes the list items as well
  _readNoDoList() async {
    List itemsDone = await db.getItemsSpecific(1);
    List itemsPending = await db.getItemsSpecific(0);
    _itemList.clear();

    ///Add pending items in main list on top
    itemsPending.forEach((item) {
      setState(() {
        ItemTodo noToDoItem = ItemTodo.map(item);
        _itemList.add(noToDoItem);
        print('item ${noToDoItem.itemName} status ${noToDoItem.isDone}');
      });
    });

    setState(() {
      ///No pending left: Add an ampty item with isDONE = -2. Helpful for showing No pending row item
      if (itemsPending.length == 0 && itemsDone.length > 0) {
        ItemTodo emptyItem = ItemTodo('', '', '');
        emptyItem.isDone = IS_FINISH;
        _itemList.add(emptyItem);
        print('item ${emptyItem.itemName} status ${emptyItem.isDone}');
      }

      ///No pending left: Add an ampty item with isDONE = -2. Helpful for showing completed item header
      if (itemsDone.length > 0) {
        ItemTodo emptyItem = ItemTodo('', '', '');
        emptyItem.isDone = IS_HEADER;
        _itemList.add(emptyItem);
        print('item ${emptyItem.itemName} status ${emptyItem.isDone}');
      }
    });

    ///Add done items in main list
    itemsDone.forEach((item) {
      setState(() {
        ItemTodo noToDoItem = ItemTodo.map(item);
        _itemList.add(noToDoItem);
        print('item ${noToDoItem.itemName} status ${noToDoItem.isDone}');
      });
    });

    print('total list size ${_itemList.length}');
  }

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  ///Delete an item
  _deleteItem(ItemTodo item, int index) async {
    await db.deleteItem(item.id);

    setState(() {
      _itemList.removeAt(index);
    });
  }

  ///Mark as done
  _marItemAsDone(ItemTodo item, int index) async {
    ItemTodo newItem = ItemTodo.fromMap({
      "itemName": item.itemName,
      "dateCreated": item.dateCreated,
      "dateModified": dateFormatted(),
      "id": item.id,
      "isDone": 1
    });

    _handleUpdateItem(index, newItem);
  }

  ///Edit item only shows dialog on item which is not DONE.
  _prepareEditItem(ItemTodo itemOld, int index) {
    if (itemOld.isDone == 1) {
      return null;
    }
    print('itemEdit ${itemOld.itemName} status ${itemOld.isDone}');
    _textEditController.text = itemOld.itemName;

    var alert = AlertDialog(
      title: Text('Edit Item'),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Item',
                hintText: 'edit',
                icon: Icon(Icons.update),
              ),
            ),
          ),
          //End of the view
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              ItemTodo newItem = ItemTodo.fromMap({
                "itemName": _textEditController.text,
                "dateCreated": itemOld.dateCreated,
                "dateModified": dateFormatted(),
                "id": itemOld.id,
                "isDone": itemOld.isDone,
              });

              //Just replace the new item in the view only
              _handleUpdateItem(index, newItem);

              Navigator.pop(context); //close dialog
            },
            child: Text('Update')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  ///Edit item action
  void _handleUpdateItem(int index, ItemTodo newItem) async {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName = newItem.itemName;
      });
    });

    print('item ${newItem.itemName} status ${newItem.isDone}');

    //update DB
    await db.udpateItem(newItem);

    setState(() {
      _readNoDoList(); //items actually from DB
    });
  }
}
