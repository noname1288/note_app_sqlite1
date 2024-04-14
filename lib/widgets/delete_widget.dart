import 'package:flutter/material.dart';

class DeleteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete'),
      actions: [
        ElevatedButton(onPressed: (){}, child: Text('Yes')),
        FilledButton(onPressed: (){}, child: Text('No')),
      ],
    );
  }
}
