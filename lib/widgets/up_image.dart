import 'package:flutter/material.dart';

class UpImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Up Image'),
      actions: [
        ElevatedButton(onPressed: (){}, child: Text('Yes')),
        FilledButton(onPressed: (){}, child: Text('No')),
      ],
    );
  }
}