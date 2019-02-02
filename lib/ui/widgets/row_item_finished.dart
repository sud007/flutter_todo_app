import 'package:flutter/material.dart';

class RowItemFinished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      child: Container(
        margin: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        color: Colors.white10,
        height: 60.0,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 32.0,
              color: Colors.white30,
            ),
            Text(
              'Voila! No Items Pending!',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }
}
