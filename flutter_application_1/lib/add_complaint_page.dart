import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/model/userModel.dart';

class AddComplaintPage extends StatefulWidget {
  final User user;

  AddComplaintPage({required this.user});

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void addComplaint() {
    final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('complaints');

    String newComplaintKey = databaseRef.push().key ?? '';
    databaseRef.child(newComplaintKey).set({
      'location': locationController.text,
      'description': descriptionController.text,
      'status': 'Pending',
      'userId': widget.user.id, // Menyimpan ID pengguna untuk mengaitkan komplain dengan pengguna
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: widget.user)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add complaint: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Complaint'),
        backgroundColor: Color(0xFF436a95), // Warna latar belakang AppBar
      ),
      body: 
        Container(
          color: Color(0xFFF7EFEA),
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: null, // Agar bisa menulis lebih dari satu baris
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addComplaint();
                },
                child: Text('Submit Complaint'),
              ),
            ],
          ),
      ),
    );
  }
}
