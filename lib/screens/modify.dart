import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class modify extends StatefulWidget {
  modify(
      {super.key,
      required this.description,
      required this.amount,
      required this.docToEdit});

  final String description, amount, docToEdit;

  @override
  State<modify> createState() => _modifyState();
}

class _modifyState extends State<modify> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  update() async {
    await FirebaseFirestore.instance
        .collection('description')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('mydescription')
        .doc(widget.docToEdit)
        .update({
      'description': _descriptionController.text,
      'amount': _amountController.text,
    }).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("successfully edited")));
  }

  delete() async {
    await FirebaseFirestore.instance
        .collection('description')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('mydescription')
        .doc(widget.docToEdit)
        .delete()
        .whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("successfully deleted")));
  }

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.description);
    _amountController = TextEditingController(text: widget.amount);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: delete,
              icon: Icon(
                Icons.delete,
                color: Color.fromRGBO(234, 4, 4, 0.667),
              ))
        ],
        title: Text("Modify your data"),
        backgroundColor: Color.fromARGB(255, 5, 234, 127),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'modify',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: update,
                  child: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
