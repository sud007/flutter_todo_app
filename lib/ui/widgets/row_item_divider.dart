import 'package:flutter/material.dart';

class RowHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 32.0),
          ),
          Text(
            'COMPLETED ITEMS',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: Colors.white70),
          ),
          Divider(
            color: Colors.white70,
            height: 4.0,
          )
        ],
      ),
    );
  }
}
