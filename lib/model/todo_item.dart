import 'package:flutter/material.dart';

class ItemTodo extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  String _dateModified;
  int _id;
  int _isDone = 0;

  String get itemName => _itemName;

  set itemName(String value) {
    _itemName = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getViewByItemStatus(),
        ],
      ),
    );
  }

  Column _getViewByItemStatus() {
    if (isDone == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _itemName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Text(
              _getTimeLabel(),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _itemName,
            style: TextStyle(
                color: Colors.white30,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
                fontSize: 16.0),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Text(
              _getTimeLabel(),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white30,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      );
    }
  }

  String _getTimeLabel() {
    if (isDone == 0) {
      return _dateCreated == _dateModified
          ? _dateCreated
          : '$_dateCreated | Updated on $_dateModified';
    } else {
      return _dateCreated == _dateModified
          ? _dateCreated
          : 'Completed on $_dateModified';
    }
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get dateCreated => _dateCreated;

  set dateCreated(String value) {
    _dateCreated = value;
  }

  String get dateModified => _dateModified;

  set dateModified(String value) {
    _dateModified = value;
  }

  int get isDone => _isDone;

  set isDone(int value) {
    _isDone = value;
  }

  ItemTodo(this._itemName, this._dateCreated, this._dateModified);

  ItemTodo.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
    this._dateModified = obj['dateModified'];
    this._isDone = obj['isDone'];
    this._id = obj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    map['isDone'] = _isDone;
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  ItemTodo.fromMap(Map<String, dynamic> map) {
    this._itemName = map['itemName'];
    this._dateCreated = map['dateCreated'];
    this._dateModified = map['dateModified'];
    this._isDone = map['isDone'];
    this._id = map['id'];
  }
}
