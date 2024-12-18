import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/modify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String uid = "";
  initState() {
    getcurrentuserid();
    super.initState();
  }

  getcurrentuserid() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  savebutton() async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("description")
        .doc(uid)
        .collection('mydescription')
        .doc(time.toString())
        .set({
      'amount': _amountController.text,
      'description': _descriptionController.text,
      'time': time.toString(),
    }).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("successfully saved")));
  }

  _openAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: savebutton,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('description')
            .doc(uid)
            .collection('mydescription')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => modify(
                            description: docs[index]['description'],
                            amount: docs[index]['amount'],
                            docToEdit: docs[index]['time'],
                          ),
                        ));
                  },
                  child: Card(
                    color: Colors.grey.shade100,
                    margin: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: 140,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs[index]['description'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                              maxLines: 3,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                              docs[index]['amount'].toString())
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
